unit UnitEstados.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json;

type
  TEstadosController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TEstadosController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitEstados.Model,
  UnitTabela.Helper.Json;

class procedure TEstadosController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Estados: TEstados;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    Estados := TEstados.Create(TDatabase.Connection);
    Estados.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    Estados.DisposeOf;
  end;
end;

class procedure TEstadosController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Estados: TEstados;
    aJson: TJSONArray;
    Query: iQuery;
begin
  aJson := TJSONArray.Create;
  Query := TDatabase.Query;
  try
    Estados := TEstados.Create(TDatabase.Connection);
    Estados.CriaTabela;
    ////
    Query.Open('SELECT EST_CODIGO FROM ESTADOS ORDER BY EST_CODIGO');
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      Estados.BuscaDadosTabela(Query.Dataset.FieldByName('EST_CODIGO').AsInteger);
      aJson.Add(Estados.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    Estados.DisposeOf;
  end;
end;

class procedure TEstadosController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Estados: TEstados;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    Estados := TEstados.Create(TDatabase.Connection);
    Estados.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(Estados.ToJsonObject);
  finally
    Estados.DisposeOf;
  end;
end;

class procedure TEstadosController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Estados: TEstados;
begin
  try
    Estados := TEstados.Create(TDatabase.Connection).fromJson<TEstados>(Req.Body);
    if Estados.Codigo = 0 then
        Estados.Codigo := GeraCodigo('ESTADOS', 'EST_CODIGO');
    Estados.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Estados.ToJsonObject);
  finally
    Estados.DisposeOf;
  end;
end;

class procedure TEstadosController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Estados: TEstados;
begin
  try
    Estados := TEstados.Create(TDatabase.Connection).fromJson<TEstados>(Req.Body);
    Estados.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Estados.ToJsonObject);
  finally
    Estados.DisposeOf;
  end;
end;

class procedure TEstadosController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/estados')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/estados/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
end;

end.
