program backendMocoes;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  System.Math,
  System.SysUtils,
  UnitDatabase in 'src\Database\UnitDatabase.pas',
  UnitConstants in 'src\Utils\UnitConstants.pas',
  UnitFunctions in 'src\Utils\UnitFunctions.pas',
  Login.Controller in 'src\Modulos\Login\Login.Controller.pas',
  UnitCidades.Controller in 'src\Modulos\Cidades\UnitCidades.Controller.pas',
  UnitCidades.Model in 'src\Modulos\Cidades\UnitCidades.Model.pas',
  UnitEstados.Controller in 'src\Modulos\Estados\UnitEstados.Controller.pas',
  UnitEstados.Model in 'src\Modulos\Estados\UnitEstados.Model.pas',
  UnitCandidatos.Model in 'src\Modulos\Candidatos\UnitCandidatos.Model.pas',
  UnitCandidatos.Controller in 'src\Modulos\Candidatos\UnitCandidatos.Controller.pas',
  UnitMocoes.Model in 'src\Modulos\Mocoes\UnitMocoes.Model.pas',
  UnitMocoes.Controller in 'src\Modulos\Mocoes\UnitMocoes.Controller.pas',
  UnitHistoricoMocoes.Model in 'src\Modulos\Historico\UnitHistoricoMocoes.Model.pas',
  UnitHistoricoMocoes.Controller in 'src\Modulos\Historico\UnitHistoricoMocoes.Controller.pas',
  UnitUsuarios.Model in 'src\Modulos\Usuarios\UnitUsuarios.Model.pas';

var
	Porta: integer;
begin
  //middlewares
  THorse
  	.Use(CORS)
    .Use(Jhonson);

  //controllers
 	TLoginController.Router;
  TEstadosController.Router;
  TCidadesController.Router;
  TCandidatosController.Router;
  TMocoesController.Router;
  THistoricoMocoesController.Router;
    
  //config port server
  Porta := IfThen(GetEnvironmentVariable('PORT').IsEmpty, 3333, GetEnvironmentVariable('PORT').ToInteger());
  //start server
  THorse.Listen(Porta, procedure 
  begin 
  	Writeln('Server is running on '+THorse.Port.ToString);
  end);
end.
