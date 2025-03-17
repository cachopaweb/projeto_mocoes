unit UnitHistoricoMocoes.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json;

type
  THistoricoMocoesController = class
    class procedure Router;
    class procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForVereadorID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetForCidadeID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ THistoricoMocoesController }

uses
  UnitConnection.Model.Interfaces,
  UnitDatabase,
  UnitFunctions,
  UnitHistoricoMocoes.Model,
  UnitTabela.Helper.Json, UnitCidadesMocoes.Model, UnitVereadores.Model;

class procedure THistoricoMocoesController.Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
  id: Integer;
begin
  try
    id := Req.Params.Items['id'].ToInteger();
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection);
    HistoricoMocoes.Apagar(id);
    Res.Send('').Status(THTTPStatus.NoContent);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
    aJson: TJSONArray;
    Query: iQuery;
begin
  aJson := TJSONArray.Create;
  Query := TDatabase.Query;
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection);
    HistoricoMocoes.CriaTabela;
    ////
    Query.Open('SELECT HM_CODIGO FROM HISTORICO_MOCOES ORDER BY HM_CODIGO');
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      HistoricoMocoes.BuscaDadosTabela(Query.Dataset.FieldByName('HM_CODIGO').AsInteger);
      aJson.Add(HistoricoMocoes.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.GetForVereadorID(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
    aJson: TJSONArray;
    id: Integer;
  Query: iQuery;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  Query := TDatabase.Query;
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection);
    HistoricoMocoes.CriaTabela;
    ////
    Query.Add('SELECT HM_CODIGO FROM HISTORICO_MOCOES WHERE HM_COD_CANDIDATO = :CANDIDATO');
    Query.AddParam('CANDIDATO', id);
    Query.Open();
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      HistoricoMocoes.BuscaDadosTabela(Query.Dataset.FieldByName('HM_CODIGO').AsInteger);
      aJson.Add(HistoricoMocoes.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.GetForCidadeID(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
    aJson: TJSONArray;
    id: Integer;
  Query: iQuery;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  Query := TDatabase.Query;
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection);
    HistoricoMocoes.CriaTabela;
    ////
    Query.Add('SELECT HM_CODIGO FROM HISTORICO_MOCOES JOIN VEREADORES ON HM_COD_VEREADOR = VER_CODIGO');
		Query.Add('WHERE VER_CID = :CIDADE');
    Query.AddParam('CIDADE', id);
    Query.Open();
    Query.Dataset.First;
    while not Query.Dataset.Eof do
    begin
      HistoricoMocoes.BuscaDadosTabela(Query.Dataset.FieldByName('HM_CODIGO').AsInteger);
      aJson.Add(HistoricoMocoes.ToJsonObject);
      Query.Dataset.Next;
    end;
    Res.Send<TJSONArray>(aJson);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.GetForID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
    aJson: TJSONArray;
    id: Integer;
begin
  aJson := TJSONArray.Create;
  id := Req.Params.Items['id'].ToInteger();
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection);
    HistoricoMocoes.BuscaDadosTabela(id);
    Res.Send<TJSONObject>(HistoricoMocoes.ToJsonObject);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var 
	HistoricoMocoes: THistoricoMocoes;
  CidadesMocoes: TCidadesMocoes;
  Query: iQuery;
  Vereador: TVereadores;
begin
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection).fromJson<THistoricoMocoes>(Req.Body);
    if HistoricoMocoes.Codigo = 0 then
        HistoricoMocoes.Codigo := GeraCodigo('HISTORICO_MOCOES', 'HM_CODIGO');
    HistoricoMocoes.DataCriacao := Now;
    HistoricoMocoes.SalvaNoBanco(1);
    //busca cidade vereador
    Vereador := TVereadores.Create(TDatabase.Connection);
    CidadesMocoes := TCidadesMocoes.Create(TDatabase.Connection);
    try
      Vereador.CriaTabela;
      Vereador.BuscaDadosTabela(HistoricoMocoes.CodVereador);
	    //atualiza ou cria o registro de ligação de moções com cidades
      CidadesMocoes.CriaTabela;
			CidadesMocoes.Codigo    := Vereador.CodCidade;
			CidadesMocoes.CodCidade := Vereador.CodCidade;
			CidadesMocoes.CodMocao  := HistoricoMocoes.CodMocao;
			CidadesMocoes.Status    := HistoricoMocoes.Status;
      CidadesMocoes.SalvaNoBanco();
		finally
      Vereador.DisposeOf;
      CidadesMocoes.DisposeOf;    	
    end;
    Res.Send<TJSONObject>(HistoricoMocoes.ToJsonObject);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.Put(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var HistoricoMocoes: THistoricoMocoes;
begin
  try
    HistoricoMocoes := THistoricoMocoes.Create(TDatabase.Connection).fromJson<THistoricoMocoes>(Req.Body);
    HistoricoMocoes.SalvaNoBanco(1);
    Res.Send<TJSONObject>(HistoricoMocoes.ToJsonObject);
  finally
    HistoricoMocoes.DisposeOf;
  end;
end;

class procedure THistoricoMocoesController.Router;
begin
  THorse.Group
        .Prefix('/v1')
        .Route('/historicoMocoes')
          .Get(Get)
          .Post(Post)
          .Put(Put)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/historicoMocoes/:id')
          .Get(GetForID)
          .Delete(Delete)
        .&End
        .Group
        .Prefix('/v1')
        .Route('/historicoMocoes/vereador/:id')
          .Get(GetForVereadorID)          
        .&End
        .Group
        .Prefix('/v1')
        .Route('/historicoMocoes/cidade/:id')
          .Get(GetForCidadeID)          
        .&End
end;

end.
