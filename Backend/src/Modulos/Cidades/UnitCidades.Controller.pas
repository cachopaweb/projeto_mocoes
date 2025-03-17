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
  UnitTabela.Helper.Json, UnitHistoricoMocoes.Model, UnitCidadesMocoes.Model;

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
  oJson: TJSONObject;
  CidadesMocoes: TCidadesMocoes;
begin
  aJson := TJSONArray.Create;
  if not Req.Query.ContainsKey('estado') then  
  	raise Exception.Create('Estado não informado');
  Estado := Req.Query.Items['estado'].ToInteger;
  Query := TDatabase.Query;
  try
  	CidadesMocoes := TCidadesMocoes.Create(TDatabase.Connection);
    try
      CidadesMocoes.CriaTabela;
    finally
      CidadesMocoes.DisposeOf;
    end;
    Cidades := TCidades.Create(TDatabase.Connection);
    Cidades.CriaTabela;
    ////
    Query.Add('SELECT CID_CODIGO, CID_UF, CID_CODIGO_IBGE, CID_EST, CID_NOME, CM_STATUS ');
    Query.Add('FROM CIDADES LEFT JOIN CIDADES_MOCOES ON CID_CODIGO = CM_CID WHERE CID_EST = :ESTADO ORDER BY CID_NOME');
    Query.AddParam('ESTADO', Estado);
    Query.Open();
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      oJson := TJSONObject.Create;
      oJson.AddPair('codigo', TJSONNumber.Create(Query.DataSet.FieldByName('CID_CODIGO').AsInteger));
      oJson.AddPair('uf', Query.DataSet.FieldByName('CID_UF').AsString);
      oJson.AddPair('codigo_ibge', TJSONNumber.Create(Query.DataSet.FieldByName('CID_CODIGO_IBGE').AsInteger));
      oJson.AddPair('est', TJSONNumber.Create(Query.DataSet.FieldByName('CID_EST').AsInteger));
      oJson.AddPair('nome', Query.DataSet.FieldByName('CID_NOME').AsString);
      oJson.AddPair('status', Query.DataSet.FieldByName('CM_STATUS').AsString);
      aJson.Add(oJson);
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
