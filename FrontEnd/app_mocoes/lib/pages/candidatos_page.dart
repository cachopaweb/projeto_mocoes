import 'package:app_mocoes/models/mocoes_model.dart';
import 'package:app_mocoes/repositories/mocoes_repository.dart';
import 'package:flutter/material.dart';

import '../models/candidatos_model.dart';
import '../models/cidades_model.dart';
import '../repositories/candidatos_repository.dart';

class CandidatosPage extends StatelessWidget {
  final CidadesModel cidadesModel;
  final MocoesModel mocoesModel;
  final repository = CandidatosRepository();
  final historicoRepository = MocoesRepository();

  CandidatosPage(
      {super.key, required this.cidadesModel, required this.mocoesModel});

  _buildSuccess(BuildContext context, List<CandidatosModel> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        return FutureBuilder(
            future:
                historicoRepository.fetchHistoricoMocoes(lista[index].codigo),
            builder: (context, snapshot) {
              final hasHistorico =
                  snapshot.hasData && (snapshot.data?.isNotEmpty ?? false);
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/historico',
                    arguments: {
                      'candidato': lista[index],
                      'mocao': mocoesModel
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
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        lista[index].foto,
                        headers: {"Access-Control-Allow-Origin": "*"},
                      ),
                      foregroundImage:
                          const AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                ),
              );
            });
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

  _buildBody(BuildContext context) {
    return FutureBuilder(
      future: repository.fetchCandidatos(cidadesModel.est, cidadesModel),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<CandidatosModel>> result) when result.hasData =>
          _buildSuccess(context, result.data!),
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
      body: _buildBody(context),
    );
  }
}
