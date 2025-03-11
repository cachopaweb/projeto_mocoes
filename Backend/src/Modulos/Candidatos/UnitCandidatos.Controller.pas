unit UnitCandidatos.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json,
  UnitClientREST.Model.Interfaces;

type
  TCandidatosController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TCandidatosController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitCandidatos.Model,
  UnitTabela.Helper.Json,  
  UnitClientREST.Model;

const URL_Candidatos = 'https://cdn-apuracao.estadao.com.br/2024/apuracao/primeiro-turno/vereador/';

class procedure TCandidatosController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Candidatos: TCandidatos;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    Candidatos := TCandidatos.Create(TDatabase.Connection);
    Candidatos.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    Candidatos.DisposeOf;
  end;
end;

class procedure TCandidatosController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
	Candidatos: TCandidatos;
	aJson     : TJSONArray;
	Query     : iQuery;
	Cidade    : string;
	Estado    : string;
  Response: TClientResult;
  JsonArray: TJSONArray;
  i: Integer;
  JArrayCandidatos: TJSONArray;
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
    Candidatos := TCandidatos.Create(TDatabase.Connection);
    Candidatos.CriaTabela;
    ////
    Query.Open(Format('SELECT FIRST 1 CAN_CODIGO FROM CANDIDATOS WHERE CAN_CID = %d ORDER BY CAN_CODIGO', [CodCidade]));
    if Query.DataSet.IsEmpty then
    begin
      //busca na API caso nunca foi carregado
      Response := TClientREST.New(URL_Candidatos+Estado+'/'+Cidade+'.json').Get;      
      if Response.StatusCode = 200 then
      begin
        JsonObj := TJSONObject.ParseJSONValue(Response.Content) as TJSONObject;
        try  
        	JArrayCandidatos := JsonObj.GetValue<TJSONArray>('candidatos');            
          for j := 0 to Pred(JArrayCandidatos.Count) do
          begin
            Candidatos := Candidatos.fromJson<TCandidatos>(JArrayCandidatos.Items[j].ToJSON);
            Candidatos.Codigo := GeraCodigo('CANDIDATOS', 'CAN_CODIGO');
            Candidatos.CodCidade := CodCidade;
      			Candidatos.SalvaNoBanco();
          end;
        finally
          JsonArray.Free;
        end;
      end;
    end;
    Query.Open(Format('SELECT CAN_CODIGO FROM CANDIDATOS WHERE CAN_CID = %d ORDER BY CAN_CODIGO', [CodCidade]));
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      Candidatos.BuscaDadosTabela(Query.Dataset.FieldByName('CAN_CODIGO').AsInteger);
      aJson.Add(Candidatos.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    Candidatos.DisposeOf;
  end;
end;

class procedure TCandidatosController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Candidatos: TCandidatos;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    Candidatos := TCandidatos.Create(TDatabase.Connection);
    Candidatos.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(Candidatos.ToJsonObject);
  finally
    Candidatos.DisposeOf;
  end;
end;

class procedure TCandidatosController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Candidatos: TCandidatos;
begin
  try
    Candidatos := TCandidatos.Create(TDatabase.Connection).fromJson<TCandidatos>(Req.Body);
    if Candidatos.Codigo = 0 then
        Candidatos.Codigo := GeraCodigo('CANDIDATOS', 'CAN_CODIGO');
    Candidatos.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Candidatos.ToJsonObject);
  finally
    Candidatos.DisposeOf;
  end;
end;

class procedure TCandidatosController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Candidatos: TCandidatos;
begin
  try
    Candidatos := TCandidatos.Create(TDatabase.Connection).fromJson<TCandidatos>(Req.Body);
    Candidatos.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Candidatos.ToJsonObject);
  finally
    Candidatos.DisposeOf;
  end;
end;

class procedure TCandidatosController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/candidatos')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/candidatos/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
end;

end.
