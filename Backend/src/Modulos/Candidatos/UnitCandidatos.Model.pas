unit UnitCandidatos.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
	[TNomeTabela('CANDIDATOS', 'CAN_CODIGO')]
  TCandidatos = class(TTabela)
  private
  	FCodigo: integer;
    FNome: string;
    FClassificacao: Integer;
    FClassificacaoTSE: Integer;
    FColigacao: string;
    FEleito: string;
    FFoto: string;
    FPartido: string;
    FUrlCandidato: string;
    FVotos: string;
    FCodCidade: integer;
  published
  	[TCampo('CAN_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
  	property Codigo: integer read FCodigo write FCodigo;
    [TCampo('CAN_NOME', 'VARCHAR(200)')]
    property Nome: string read FNome write FNome;
    [TCampo('CAN_CLASSIFICACAO', 'INTEGER')]
    property Classificacao: Integer read FClassificacao write FClassificacao;
    [TCampo('CAN_CLASSIFICACAO_TSE', 'INTEGER')]
    property ClassificacaoTSE: Integer read FClassificacaoTSE write FClassificacaoTSE;
    [TCampo('CAN_COLIGACAO', 'VARCHAR(50)')]
    property Coligacao: string read FColigacao write FColigacao;
    [TCampo('CAN_ELEITO', 'VARCHAR(10)')]
    property Eleito: string read FEleito write FEleito;
    [TCampo('CAN_FOTO', 'VARCHAR(1000)')]
    property Foto: string read FFoto write FFoto;
    [TCampo('CAN_PARTIDO', 'VARCHAR(50)')]
    property Partido: string read FPartido write FPartido;
    [TCampo('CAN_URL_CANDIDATO', 'VARCHAR(1000)')]
    property UrlCandidato: string read FUrlCandidato write FUrlCandidato;
    [TCampo('CAN_VOTOS', 'VARCHAR(30)')]
    property Votos: string read FVotos write FVotos;
    [TCampo('CAN_CID', 'INTEGER')]
    property CodCidade: integer read FCodCidade write FCodCidade;
  end;
	

implementation

end.
