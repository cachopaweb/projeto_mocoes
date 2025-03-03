unit Login.Controller;

interface
uses
  Horse,
  Horse.Commons,
  Classes,
  SysUtils,
  System.Json,
  DB,
  UnitConnection.Model.Interfaces;


type
  TLoginController = class
    class procedure Router;
    class procedure Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLoginController }

uses
	UnitConstants, 
  UnitDatabase, 
  UnitFunctions, 
  UnitUsuarios.Model;

class procedure TLoginController.GetUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var Query: iQuery;
  aJson: TJSONArray;
  oJson: TJSONObject;
  Usuarios: TUsuarios;
begin
	Usuarios := TUsuarios.Create(TDatabase.Connection);
  try
    Usuarios.CriaTabela;
  finally
    Usuarios.DisposeOf;
  end;
  Query := TDatabase.Query;
  Query.Open('SELECT USU_CODIGO, USU_LOGIN FROM USUARIOS ORDER BY USU_LOGIN');
  aJson := TJSONArray.Create;
  Query.DataSet.First;
  while not Query.DataSet.Eof do
  begin
    oJson := TJSONObject.Create;
    oJson.AddPair('codigo', TJSONNumber.Create(Query.DataSet.FieldByName('USU_CODIGO').AsInteger));
    oJson.AddPair('login', Query.DataSet.FieldByName('USU_LOGIN').AsString);
    aJson.AddElement(oJson);
    Query.DataSet.Next;
  end;
  Res.Send<TJSONArray>(aJson);
end;

class procedure TLoginController.Post(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Query: iQuery;
  login: String;
  senha: string;
  oJson: TJSONObject;
begin
  if Req.Body <> '' then
  begin
    login := Req.Body<TJSONObject>.GetValue<string>('login');
    senha := Req.Body<TJSONObject>.GetValue<string>('senha');
    Query := TDatabase.Query;
    Query.Clear;
    Query.Add('SELECT USU_CODIGO, USU_LOGIN FROM USUARIOS WHERE USU_LOGIN = :LOGIN AND USU_SENHA = :SENHA');
    Query.AddParam('LOGIN', login);
    Query.AddParam('SENHA', senha);
    Query.Open();
    if not Query.DataSet.IsEmpty then
    begin
      oJson := TJSONObject.Create;
      oJson.AddPair('codigo', TJSONNumber.Create(Query.DataSet.FieldByName('USU_CODIGO').AsInteger));
      oJson.AddPair('login', Query.DataSet.FieldByName('USU_LOGIN').AsString);
      Res.Send<TJSONObject>(oJson);
    end else
      Res.Send<TJSONObject>(TJSONObject.Create.AddPair('message', 'n�o autorizado')).Status(THTTPStatus.Unauthorized);
  end else
    Res.Status(THTTPStatus.BadRequest).Send<TJSONObject>(TJSONObject.Create.AddPair('error', 'Usuario n�o informado'));
end;

class procedure TLoginController.Router;
begin
	THorse.Group
        .Prefix('/v1')
        .Route('/login')
  				.Post(Post)
        .&End
        .Group
        .Prefix('/v1')        
        .Route('/usuarios')
        	.Get(GetUsuarios)
        .&End;
end;

end.
