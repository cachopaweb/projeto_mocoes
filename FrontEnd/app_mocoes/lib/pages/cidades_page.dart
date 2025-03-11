import 'package:app_mocoes/controllers/usuario_controller.dart';
import 'package:app_mocoes/repositories/mocoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cidades_model.dart';
import '../models/mocoes_model.dart';
import '../repositories/cidades_repository.dart';

class CidadesPage extends StatelessWidget {
  final MocoesModel mocaoModel;
  final historicoRepository = MocoesRepository();
  final respository = CidadesRepository();

  CidadesPage({super.key, required this.mocaoModel});

  _buildSuccess(BuildContext context, List<CidadesModel> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: historicoRepository
              .fetchHistoricoMocoesPorCidade(lista[index].codigo),
          builder: (context, snapshot) {
            final hasHistorico =
                snapshot.hasData && (snapshot.data?.isNotEmpty ?? false);
            return GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed('/candidatos', arguments: {
                'cidade': lista[index],
                'mocao': mocaoModel,
              }),
              child: Card(
                color: hasHistorico
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                elevation: 15,
                child: ListTile(
                  title: Text(
                    lista[index].nome,
                    style: TextStyle(
                      color: hasHistorico ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError(String error) {
    return Center(
      child: Text('Erro ao buscar cidades!\n$error'),
    );
  }

  _buildBody(BuildContext context, UsuarioController controller) {
    return FutureBuilder(
      future:
          respository.fetchCidades(controller.usuarioLogado.estadoEscolhido!),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<CidadesModel>> result) when result.hasData =>
          _buildSuccess(context, result.data!),
        (AsyncSnapshot<List<MocoesModel>> result) when !result.hasError =>
          _buildLoading(),
        (_) => _buildError(snapshot.error.toString()),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(mocaoModel.nome),
        centerTitle: true,
      ),
      body: _buildBody(context, usuarioController),
    );
  }
}
