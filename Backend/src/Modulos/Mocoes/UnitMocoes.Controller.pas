unit UnitMocoes.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json;

type
  TMocoesController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TMocoesController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitMocoes.Model,
  UnitTabela.Helper.Json;

class procedure TMocoesController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Mocoes: TMocoes;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    Mocoes := TMocoes.Create(TDatabase.Connection);
    Mocoes.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    Mocoes.DisposeOf;
  end;
end;

class procedure TMocoesController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Mocoes: TMocoes;
    aJson: TJSONArray;
    Query: iQuery;
begin
  aJson := TJSONArray.Create;
  Query := TDatabase.Query;
  try
    Mocoes := TMocoes.Create(TDatabase.Connection);
    Mocoes.CriaTabela;
    ////
    Query.Open('SELECT MOC_CODIGO FROM MOCOES ORDER BY MOC_CODIGO');
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      Mocoes.BuscaDadosTabela(Query.Dataset.FieldByName('MOC_CODIGO').AsInteger);
      aJson.Add(Mocoes.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    Mocoes.DisposeOf;
  end;
end;

class procedure TMocoesController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Mocoes: TMocoes;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    Mocoes := TMocoes.Create(TDatabase.Connection);
    Mocoes.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(Mocoes.ToJsonObject);
  finally
    Mocoes.DisposeOf;
  end;
end;

class procedure TMocoesController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Mocoes: TMocoes;
begin
  try
    Mocoes := TMocoes.Create(TDatabase.Connection).fromJson<TMocoes>(Req.Body);
    if Mocoes.Codigo = 0 then
        Mocoes.Codigo := GeraCodigo('MOCOES', 'MOC_CODIGO');
    Mocoes.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Mocoes.ToJsonObject);
  finally
    Mocoes.DisposeOf;
  end;
end;

class procedure TMocoesController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Mocoes: TMocoes;
begin
  try
    Mocoes := TMocoes.Create(TDatabase.Connection).fromJson<TMocoes>(Req.Body);
    Mocoes.SalvaNoBanco(1);
    Res.Send<TJSONObject>(Mocoes.ToJsonObject);
  finally
    Mocoes.DisposeOf;
  end;
end;

class procedure TMocoesController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/mocoes')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/mocoes/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
end;

end.
