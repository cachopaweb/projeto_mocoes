unit UnitUsuarios.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
  [TRecursoServidor('/usuarios')]
  [TNomeTabela('USUARIOS', 'USU_CODIGO')]
  TUsuarios = class(TTabela)
  private
    { private declarations }
    FCodigo: integer;
    FLogin: string;
    FFun: integer;
    FSenha: string;
  public
    { public declarations }
    [TCampo('USU_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
    property Codigo: integer read FCodigo write FCodigo;
    [TCampo('USU_LOGIN', 'VARCHAR(20)')]
    property Login: string read FLogin write FLogin;
    [TCampo('USU_SENHA', 'VARCHAR(30)')]
    property Senha: string read FSenha write FSenha;
  end;

implementation

end.
