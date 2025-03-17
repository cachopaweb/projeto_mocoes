unit UnitVereadores.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json,
  UnitClientREST.Model.Interfaces;

type
  TVereadoresController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TVereadoresController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitVereadores.Model,
  UnitTabela.Helper.Json,  
  UnitClientREST.Model;

const URL_Vereadores = 'https://cdn-apuracao.estadao.com.br/2024/apuracao/primeiro-turno/vereador/';

class procedure TVereadoresController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Vereadores: TVereadores;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    Vereadores := TVereadores.Create(TDatabase.Connection);
    Vereadores.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    Vereadores.DisposeOf;
  end;
end;

class procedure TVereadoresController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
	Vereadores: TVereadores;
	aJson     : TJSONArray;
	Query     : iQuery;
	Cidade    : string;
	Estado    : string;
  Response: TClientResult;
  JsonArray: TJSONArray;
  i: Integer;
  JArrayVereadores: TJSONArray;
  j: Integer;
  JsonObj: TJSONObject;
  CodCidade: Integer;
begin
	if not Req.Query.ContainsKey('cidadeDescricao') then
  	raise Exception.Create('Descrição da Cidade não informada!');
  if not Req.Query.ContainsKey('codCidade') then
  	raise Exception.Create('Código da Cidade não informada!');
  if not Req.Query.ContainsKey('estado') then
  	raise Exception.Create('Estado não informada!');
	Cidade := Req.Query.Items['cidadeDescricao'];
  CodCidade := Req.Query.Items['codCidade'].ToInteger();
  Estado := Req.Query.Items['estado'];
  aJson := TJSONArray.Create;
  Query := TDatabase.Query;
  try
    Vereadores := TVereadores.Create(TDatabase.Connection);
    Vereadores.CriaTabela;
    ////
    Query.Open(Format('SELECT FIRST 1 VER_CODIGO FROM VEREADORES WHERE VER_CID = %d ORDER BY VER_CODIGO', [CodCidade]));
    if Query.DataSet.IsEmpty then
    begin
      //busca na API caso nunca foi carregado
      Response := TClientREST.New(URL_Vereadores+Estado+'/'+Cidade+'.json').Get;      
      if Response.StatusCode = 200 then
      begin
        JsonObj := TJSONObject.ParseJSONValue(Response.Content) as TJSONObject;
        try  
        	JArrayVereadores := JsonObj.GetValue<TJSONArray>('candidatos');            
          for j := 0 to Pred(JArrayVereadores.Count) do
          begin
            Vereadores := Vereadores.fromJson<TVereadores>(JArrayVereadores.Items[j].ToJSON);
            Vereadores.Codigo := GeraCodigo('VEREADORES', 'VER_CODIGO');
            Vereadores.CodCidade := CodCidade;
      			Vereadores.SalvaNoBanco();
          end;
        finally
          JsonArray.Free;
        end;
      end;
    end;
    Query.Open(Format('SELECT VER_CODIGO FROM VEREADORES WHERE VER_CID = %d ORDER BY VER_CODIGO', [CodCidade]));
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      Vereadores.BuscaDadosTabela(Query.Dataset.FieldByName('VER_CODIGO').AsInteger);
      aJson.Add(Vereadores.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    Vereadores.DisposeOf;
  end;
end;

class procedure TVereadoresController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Vereadores: TVereadores;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    Vereadores := TVereadores.Create(TDatabase.Connection);
    Vereadores.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(Vereadores.ToJsonObject);
  finally
    Vereadores.DisposeOf;
  end;
end;

class procedure TVereadoresController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Vereadores: TVereadores;
begin
  try
    Vereadores := TVereadores.Create(TDatabase.Connection).fromJson<TVereadores>(Req.Body);
    if Vereadores.Codigo = 0 then
        VEREADORES.Codigo := GeraCodigo('VEREADORES', 'VER_CODIGO');
    Vereadores.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Vereadores.ToJsonObject);
  finally
    Vereadores.DisposeOf;
  end;
end;

class procedure TVereadoresController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Vereadores: TVereadores;
begin
  try
    Vereadores := TVereadores.Create(TDatabase.Connection).fromJson<TVereadores>(Req.Body);
    Vereadores.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Vereadores.ToJsonObject);
  finally
    Vereadores.DisposeOf;
  end;
end;

class procedure TVereadoresController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/vereadores')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/vereadores/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
end;

end.
