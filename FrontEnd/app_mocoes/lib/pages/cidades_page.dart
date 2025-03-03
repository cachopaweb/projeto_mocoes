import 'package:app_mocoes/controllers/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cidades_model.dart';
import '../models/mocoes_model.dart';
import '../repositories/cidades_repository.dart';

class CidadesPage extends StatelessWidget {
  final MocoesModel mocaoModel;
  final respository = CidadesRepository();

  CidadesPage({super.key, required this.mocaoModel});

  _buildSuccess(List<CidadesModel> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 15,
          child: ListTile(
            title: Text(lista[index].nome),
          ),
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
      child: Text('Erro ao buscar moções!\n$error'),
    );
  }

  _buildBody(UsuarioController controller) {
    return FutureBuilder(
      future:
          respository.fetchCidades(controller.usuarioLogado.estadoEscolhido!),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<CidadesModel>> result) when result.hasData =>
          _buildSuccess(result.data!),
        (AsyncSnapshot<List<MocoesModel>> result) when !result.hasError =>
          _buildLoading(),
        (_) => _buildError('Nada encontrado...'),
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
      body: _buildBody(usuarioController),
    );
  }
}
