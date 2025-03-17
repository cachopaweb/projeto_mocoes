unit UnitCidades.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
  [TRecursoServidor('/cidades')]
  [TNomeTabela('CIDADES', 'CID_CODIGO')]
  TCidades = class(TTabela)
  private
    { private declarations }
    FCodigo: integer;
    FUf: string;
    FCodigo_ibge: integer;
    FEst: integer;
    FNome: string;
    FUltStatus: string;
  public
    { public declarations }
    [TCampo('CID_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
    property Codigo: integer read FCodigo write FCodigo;
    [TCampo('CID_UF', 'VARCHAR(2)')]
    property Uf: string read FUf write FUf;
    [TCampo('CID_CODIGO_IBGE', 'INTEGER')]
    property Codigo_ibge: integer read FCodigo_ibge write FCodigo_ibge;
    [TCampo('CID_EST', 'INTEGER')]
    property Est: integer read FEst write FEst;
    [TCampo('CID_NOME', 'VARCHAR(100)')]
    property Nome: string read FNome write FNome;
    property UltStatus: string read FUltStatus write FUltStatus;
  end;

implementation

end.
