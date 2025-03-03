unit UnitHistoricoMocoes.Model;

interface

uses
	UnitPortalORM.Model,
  UnitMocoes.Model,
  UnitCandidatos.Model;

type
	[TNomeTabela('HISTORICO_MOCOES', 'HM_CODIGO')]
	THistoricoMocoes = class(TTabela)
	private
		FCodigo: integer;
    FCodMocao: integer;
    FCodCandidato: integer;
    FDescricao: string;
    FDataCriacao: string;
    FCodUsuario: integer;
    FMocao: TMocoes;
    FCandidato: TCandidatos;
	public
		[TCampo('HM_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
		property Codigo: integer read FCodigo write FCodigo;
    [TCampo('HM_COD_MOCAO', 'INTEGER')]
    property CodMocao: integer read FCodMocao write FCodMocao;
    [TCampo('HM_COD_CANDIDATO', 'INTEGER')]
    property CodCandidato: integer read FCodCandidato write FCodCandidato;
    [TCampo('HM_DESCRICAO', 'VARCHAR(1000)')]
    property Descricao: string read FDescricao write FDescricao;
    [TCampo('HM_DATA_CRIACAO', 'DATE')]
    property DataCriacao: string read FDataCriacao write FDataCriacao;
    [TCampo('HM_COD_USUARIO', 'INTEGER')]
    property CodUsuario: integer read FCodUsuario write FCodUsuario; 
    [TRelacionamento('MOCOES', 'MOC_CODIGO', 'HM_COD_MOCAO', TMocoes, TTipoRelacionamento.UmPraUm)]
    property Mocao: TMocoes read FMocao write FMocao;
    [TRelacionamento('CANDIDATOS', 'CAN_CODIGO', 'HM_COD_CANDIDATO', TCandidatos, TTipoRelacionamento.UmPraUm)]
    property Candidato: TCandidatos read FCandidato write FCandidato;
	end;

implementation

end.
