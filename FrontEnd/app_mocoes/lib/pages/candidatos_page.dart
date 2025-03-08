import 'package:flutter/material.dart';

import '../models/candidatos_model.dart';
import '../models/cidades_model.dart';
import '../repositories/candidatos_repository.dart';

class CandidatosPage extends StatelessWidget {
  final CidadesModel cidadesModel;
  final respository = CandidatosRepository();

  CandidatosPage({super.key, required this.cidadesModel});

  _buildSuccess(List<CandidatosModel> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 15,
          child: ListTile(
            title: Text(lista[index].nome),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                lista[index].foto,
                headers: {"Access-Control-Allow-Origin": "*"},
              ),
              foregroundImage: const AssetImage('assets/images/avatar.png'),
            ),
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
      child: Text('Erro ao buscar candidatos!\n$error'),
    );
  }

  _buildBody() {
    return FutureBuilder(
      future: respository.fetchCandidatos(cidadesModel.est, cidadesModel.nome),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<CandidatosModel>> result) when result.hasData =>
          _buildSuccess(result.data!),
        (AsyncSnapshot<List<CandidatosModel>> result) when !result.hasError =>
          _buildLoading(),
        (_) => _buildError('Nada encontrado...'),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cidadesModel.nome),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}
