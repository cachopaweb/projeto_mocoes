import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/historico_mocoes_controller.dart';
import 'controllers/usuario_controller.dart';
import 'models/cidades_model.dart';
import 'models/historico_mocoes_model.dart';
import 'models/mocoes_model.dart';
import 'pages/cidades_page.dart';
import 'pages/detalhe_historico_mocoes_page.dart';
import 'pages/historico_mocoes_page.dart';
import 'pages/mocoes_page.dart';
import 'pages/login_page.dart';
import 'pages/splash_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UsuarioController()),
      ChangeNotifierProvider(create: (context) => HistoricoMocoesController()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Moções',
      theme: AppTheme.theme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/mocoes': (context) => const MocoesPage(),
        '/cidades': (context) => CidadesPage(
              mocaoModel:
                  ModalRoute.of(context)!.settings.arguments as MocoesModel,
            ),
        '/historico': (context) {
          final arguments =
              ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

          return HistoricoMocoesPage(
            cidadesModel: arguments['cidade'] as CidadesModel,
            mocoesModel: arguments['mocao'] as MocoesModel,
          );
        },
        '/historico_detalhes': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as HistoricoMocoesModel;

          return DetalheHistoricoMocoesPage(
            historicoMocoesModel: arguments,
          );
        },
      },
    );
  }
}
