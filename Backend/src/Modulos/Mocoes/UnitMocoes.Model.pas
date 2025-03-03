unit UnitMocoes.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
	[TNomeTabela('MOCOES', 'MOC_CODIGO')]
	TMocoes = class(TTabela)
  private
    FCodigo: integer;
    FNome: string;
    FDataCriacao: TDateTime;
  published
  	[TCampo('MOC_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
    property Codigo: integer read FCodigo write FCodigo;
    [TCampo('MOC_NOME', 'VARCHAR(1000)')]
    property Nome: string read FNome write FNome;
    [TCampo('MOC_DATA_CRIACAO', 'TIMESTAMP')]
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
  end;

implementation

end.
