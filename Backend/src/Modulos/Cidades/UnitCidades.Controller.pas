unit UnitCidades.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json;

type
  TCidadesController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TCidadesController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitCidades.Model,
  UnitTabela.Helper.Json;

class procedure TCidadesController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Cidades: TCidades;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    Cidades := TCidades.Create(TDatabase.Connection);
    Cidades.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    Cidades.DisposeOf;
  end;
end;

class procedure TCidadesController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Cidades: TCidades;
    aJson: TJSONArray;
    Query: iQuery;
  Estado: Integer;
begin
  aJson := TJSONArray.Create;
  if not Req.Query.ContainsKey('estado') then  
  	raise Exception.Create('Estado não informado');
  Estado := Req.Query.Items['estado'].ToInteger;
  Query := TDatabase.Query;
  try
    Cidades := TCidades.Create(TDatabase.Connection);
    Cidades.CriaTabela;
    ////
    Query.Open(Format('SELECT CID_CODIGO FROM CIDADES WHERE CID_EST = %d ORDER BY CID_NOME', [Estado]));
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      Cidades.BuscaDadosTabela(Query.Dataset.FieldByName('CID_CODIGO').AsInteger);
      aJson.Add(Cidades.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    Cidades.DisposeOf;
  end;
end;

class procedure TCidadesController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Cidades: TCidades;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    Cidades := TCidades.Create(TDatabase.Connection);
    Cidades.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(Cidades.ToJsonObject);
  finally
    Cidades.DisposeOf;
  end;
end;

class procedure TCidadesController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Cidades: TCidades;
begin
  try
    Cidades := TCidades.Create(TDatabase.Connection).fromJson<TCidades>(Req.Body);
    if Cidades.Codigo = 0 then
        Cidades.Codigo := GeraCodigo('CIDADES', 'CID_CODIGO');
    Cidades.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Cidades.ToJsonObject);
  finally
    Cidades.DisposeOf;
  end;
end;

class procedure TCidadesController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Cidades: TCidades;
begin
  try
    Cidades := TCidades.Create(TDatabase.Connection).fromJson<TCidades>(Req.Body);
    Cidades.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Cidades.ToJsonObject);
  finally
    Cidades.DisposeOf;
  end;
end;

class procedure TCidadesController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/cidades')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/cidades/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
end;

end.
