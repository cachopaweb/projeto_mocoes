unit UnitVereadores.Model;

interface

uses
  {$IFDEF PORTALORM}
  UnitPortalORM.Model;
  {$ELSE}
  UnitBancoDeDados.Model;
  {$ENDIF}

type
	[TNomeTabela('VEREADORES', 'VER_CODIGO')]
  TVereadores = class(TTabela)
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
  	[TCampo('VER_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
  	property Codigo: integer read FCodigo write FCodigo;
    [TCampo('VER_NOME', 'VARCHAR(200)')]
    property Nome: string read FNome write FNome;
    [TCampo('VER_CLASSIFICACAO', 'INTEGER')]
    property Classificacao: Integer read FClassificacao write FClassificacao;
    [TCampo('VER_CLASSIFICACAO_TSE', 'INTEGER')]
    property ClassificacaoTSE: Integer read FClassificacaoTSE write FClassificacaoTSE;
    [TCampo('VER_COLIGACAO', 'VARCHAR(50)')]
    property Coligacao: string read FColigacao write FColigacao;
    [TCampo('VER_ELEITO', 'VARCHAR(10)')]
    property Eleito: string read FEleito write FEleito;
    [TCampo('VER_FOTO', 'VARCHAR(1000)')]
    property Foto: string read FFoto write FFoto;
    [TCampo('VER_PARTIDO', 'VARCHAR(50)')]
    property Partido: string read FPartido write FPartido;
    [TCampo('VER_URL_CANDIDATO', 'VARCHAR(1000)')]
    property UrlCandidato: string read FUrlCandidato write FUrlCandidato;
    [TCampo('VER_VOTOS', 'VARCHAR(30)')]
    property Votos: string read FVotos write FVotos;
    [TCampo('VER_CID', 'INTEGER')]
    property CodCidade: integer read FCodCidade write FCodCidade;
  end;
	

implementation

end.
