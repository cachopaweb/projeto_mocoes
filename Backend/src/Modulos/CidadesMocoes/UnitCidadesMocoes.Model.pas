unit UnitCidadesMocoes.Model;

interface

uses
	UnitPortalORM.Model;

type
	[TNomeTabela('CIDADES_MOCOES', 'CM_CODIGO')]
	TCidadesMocoes = class(TTabela)
	private
		FCodigo: integer;
    FCodCidade: integer;
    FCodMocao: integer;
    FStatus: string;
	public
		[TCampo('CM_CODIGO', 'INTEGER NOT NULL PRIMARY KEY')]
		property Codigo: integer read FCodigo write FCodigo;
    [TCampo('CM_CID', 'INTEGER REFERENCES CIDADES (CID_CODIGO)')]
    property CodCidade: integer read FCodCidade write FCodCidade;
    [TCampo('CM_MOCAO', 'INTEGER REFERENCES MOCOES (MOC_CODIGO)')]
    property CodMocao: integer read FCodMocao write FCodMocao;
    [TCampo('CM_STATUS', 'VARCHAR(30)')]
    property Status: string read FStatus write FStatus;
	end;

implementation

{ TCidadesMocoes }

end.
