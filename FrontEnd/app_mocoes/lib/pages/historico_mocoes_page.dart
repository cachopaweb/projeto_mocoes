import 'package:app_mocoes/controllers/historico_mocoes_controller.dart';
import 'package:app_mocoes/models/vereadores_model.dart';
import 'package:app_mocoes/repositories/vereadores_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/datePicker.dart';
import '../components/dropDownStatus.dart';
import '../components/dropDownVereadores.dart';
import '../controllers/usuario_controller.dart';
import '../models/cidades_model.dart';
import '../models/historico_mocoes_model.dart';
import '../models/mocoes_model.dart';
import '../repositories/mocoes_repository.dart';
import '../utils/utils.dart';
import 'detalhe_historico_mocoes_page.dart';

class HistoricoMocoesPage extends StatefulWidget {
  final CidadesModel cidadesModel;
  final MocoesModel mocoesModel;

  const HistoricoMocoesPage({
    super.key,
    required this.mocoesModel,
    required this.cidadesModel,
  });

  @override
  State<HistoricoMocoesPage> createState() => _HistoricoMocoesPageState();
}

class _HistoricoMocoesPageState extends State<HistoricoMocoesPage> {
  final repository = MocoesRepository();
  final repositoryVereadores = VereadoresRepository();

  _vaiParaDetalhes(HistoricoMocoesModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: DetalheHistoricoMocoesPage(
            historicoMocoesModel: model,
          ),
        );
      },
    );
  }

  _buildSuccess(List<HistoricoMocoesModel> lista) {
    final dateFmt = DateFormat('dd/MM/yyyy hh:mm:ss');
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        final historico = lista[index];
        return FutureBuilder(
            future: repositoryVereadores.fetchVereador(historico.codVereador),
            builder: (context, snapshot) {
              final hasData = snapshot.hasData;
              var vereador = VereadoresModel.empty();
              if (hasData) {
                vereador = snapshot.data!;
              }
              return hasData
                  ? GestureDetector(
                      onTap: () => _vaiParaDetalhes(lista[index]),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          border: Border.all(
                            width: 3,
                            color:
                                strToStatus(lista[index].status).StatusToColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lista[index].status,
                                style: TextStyle(
                                    color: strToStatus(lista[index].status)
                                        .StatusToColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                vereador.nome,
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Data Status: ${dateFmt.format(lista[index].dataStatus)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator();
            });
      },
    );
  }

  _buildLoading() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildError(String error) {
    return Center(
      child: Text('Erro ao buscar HistoricoMocoesModel!\n$error'),
    );
  }

  Future<bool> _buildModalCadastroHistoricoMocoes(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Histórico de Moções'),
          content: TelaCadastroHistoricoMocoes(
            cidadesModel: widget.cidadesModel,
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red)),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              child: const Text(
                "Salvar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  _buildBody() {
    return FutureBuilder(
      future:
          repository.fetchHistoricoMocoesPorCidade(widget.cidadesModel.codigo),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<HistoricoMocoesModel>> result)
            when result.hasData =>
          _buildSuccess(result.data!),
        (AsyncSnapshot<List<HistoricoMocoesModel>> result)
            when (result.connectionState == ConnectionState.waiting) =>
          _buildLoading(),
        (_) => _buildError(snapshot.error.toString()),
      },
    );
  }

  _buildShowMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cidadesModel.nome),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controllerUsuario =
              Provider.of<UsuarioController>(context, listen: false);
          final historicoController =
              Provider.of<HistoricoMocoesController>(context, listen: false);
          final result = await _buildModalCadastroHistoricoMocoes(context);
          if (result) {
            final historicoMocoesModel = HistoricoMocoesModel(
              codigo: 0,
              descricao: historicoController.getDescricao(),
              dataCriacao: DateTime.now(),
              codVereador: historicoController.getVereador().codigo,
              codMocao: widget.mocoesModel.codigo,
              codUsuario: controllerUsuario.usuarioLogado.codigo,
              status: historicoController.getStatus().StatusToStr,
              dataStatus: historicoController.getDataStatus(),
            );
            final resultInsereHistorico =
                await repository.createHistoricoMocoes(historicoMocoesModel);
            if (resultInsereHistorico) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                _buildShowMessage('Moção criada com sucesso', context);
                setState(() {});
              }
            }
          }
        },
        child: const Icon(
          Icons.add_comment,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TelaCadastroHistoricoMocoes extends StatefulWidget {
  final CidadesModel cidadesModel;

  const TelaCadastroHistoricoMocoes({
    super.key,
    required this.cidadesModel,
  });

  @override
  State<TelaCadastroHistoricoMocoes> createState() =>
      _TelaCadastroMocoesState();
}

class _TelaCadastroMocoesState extends State<TelaCadastroHistoricoMocoes> {
  final _controllerDescricao = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerDescricao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerHistorico =
        Provider.of<HistoricoMocoesController>(context, listen: false);
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                Dropdownvereadores(
                  cidadesModel: widget.cidadesModel,
                  codEstado: widget.cidadesModel.est,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Dropdownstatus(),
                const SizedBox(
                  height: 10,
                ),
                Datepicker(
                  onChanged: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      controllerHistorico.setDataStatus(DateTime.parse(value));
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Histórico'),
                TextFormField(
                  maxLines: 10,
                  controller: _controllerDescricao,
                  decoration: const InputDecoration(
                      hintText: 'Informe o histórico da moção',
                      border: OutlineInputBorder()),
                  onChanged: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      controllerHistorico.setDescricao(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
