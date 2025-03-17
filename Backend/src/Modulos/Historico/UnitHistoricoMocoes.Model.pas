unit UnitHistoricoMocoes.Model;

interface

uses
	UnitPortalORM.Model,
  UnitMocoes.Model,
  UnitVereadores.Model;

type
	[TNomeTabela('HISTORICO_MOCOES', 'HM_CODIGO')]
	THistoricoMocoes = class(TTabela)
	private
		FCodigo: integer;
    FCodMocao: integer;
    FCodVereador: integer;
    FDescricao: string;
    FDataCriacao: TDateTime;
    FCodUsuario: integer;
    FMocao: TMocoes;
    FVereador: TVereadores;
    FStatus: string;
    FDataStatus: TDateTime;
	public
		[TCampo('HM_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
		property Codigo: integer read FCodigo write FCodigo;
    [TCampo('HM_COD_MOCAO', 'INTEGER')]
    property CodMocao: integer read FCodMocao write FCodMocao;
    [TCampo('HM_COD_VEREADOR', 'INTEGER')]
    property CodVereador: integer read FCodVereador write FCodVereador;
    [TCampo('HM_DESCRICAO', 'VARCHAR(1000)')]
    property Descricao: string read FDescricao write FDescricao;
    [TCampo('HM_DATA_CRIACAO', 'TIMESTAMP')]
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    [TCampo('HM_COD_USUARIO', 'INTEGER')]
    property CodUsuario: integer read FCodUsuario write FCodUsuario; 
    [TRelacionamento('MOCOES', 'MOC_CODIGO', 'HM_COD_MOCAO', TMocoes, TTipoRelacionamento.UmPraUm)]
    property Mocao: TMocoes read FMocao write FMocao;
    [TRelacionamento('VEREADORES', 'VER_CODIGO', 'HM_COD_VEREADOR', TVereadores, TTipoRelacionamento.UmPraUm)]
    property Vereador: TVereadores read FVereador write FVereador;
    [TCampo('HM_STATUS', 'VARCHAR(30)')]
    property Status: string read FStatus write FStatus;
    [TCampo('HM_DATA_STATUS', 'TIMESTAMP')]
    property DataStatus: TDateTime read FDataStatus write FDataStatus;
	end;

implementation

end.
