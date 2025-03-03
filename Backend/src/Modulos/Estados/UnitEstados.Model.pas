unit UnitEstados.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
  [TRecursoServidor('/estados')]
  [TNomeTabela('ESTADOS', 'EST_CODIGO')]
  TEstados = class(TTabela)
  private
    { private declarations }
    FCodigo: integer;
    FSigla: string;
    FNome: string;
    FCodigo_ibge: integer;
  public
    { public declarations }
    [TCampo('EST_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
    property Codigo: integer read FCodigo write FCodigo;
    [TCampo('EST_SIGLA', 'CHAR(2)')]
    property Sigla: string read FSigla write FSigla;
    [TCampo('EST_NOME', 'VARCHAR(100)')]
    property Nome: string read FNome write FNome;
    [TCampo('EST_CODIGO_IBGE', 'INTEGER')]
    property Codigo_ibge: integer read FCodigo_ibge write FCodigo_ibge;
  end;

implementation

end.
