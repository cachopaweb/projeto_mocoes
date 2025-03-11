import 'package:app_mocoes/controllers/usuario_controller.dart';
import 'package:app_mocoes/models/candidatos_model.dart';
import 'package:app_mocoes/models/mocoes_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/historico_mocoes_model.dart';
import '../repositories/mocoes_repository.dart';

class HistoricoMocoesPage extends StatefulWidget {
  final CandidatosModel candidatosModel;
  final MocoesModel mocoesModel;

  const HistoricoMocoesPage(
      {super.key, required this.candidatosModel, required this.mocoesModel});

  @override
  State<HistoricoMocoesPage> createState() => _HistoricoMocoesPageState();
}

class _HistoricoMocoesPageState extends State<HistoricoMocoesPage> {
  final respository = MocoesRepository();

  final descricaoController = TextEditingController();

  _buildSuccess(List<HistoricoMocoesModel> lista) {
    final dateFmt = DateFormat('dd/MM/yyyy hh:mm:ss');
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  lista[index].descricao,
                  maxLines: lista[index].descricao.length,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Data criação: ${dateFmt.format(lista[index].dataCriacao)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
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
            descricaoController: descricaoController,
            historicoMocoesModel: HistoricoMocoesModel.empty(),
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
      future: respository.fetchHistoricoMocoes(widget.candidatosModel.codigo),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<HistoricoMocoesModel>> result)
            when result.hasData =>
          _buildSuccess(result.data!),
        (AsyncSnapshot<List<HistoricoMocoesModel>> result)
            when !result.hasError =>
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
        title: Text(widget.candidatosModel.nome),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controllerUsuario =
              Provider.of<UsuarioController>(context, listen: false);
          final result = await _buildModalCadastroHistoricoMocoes(context);
          if (result) {
            final historicoMocoesModel = HistoricoMocoesModel(
              codigo: 0,
              descricao: descricaoController.text,
              dataCriacao: DateTime.now(),
              codCandidato: widget.candidatosModel.codigo,
              codMocao: widget.mocoesModel.codigo,
              codUsuario: controllerUsuario.usuarioLogado.codigo,
            );
            final resultInsereHistorico =
                await respository.createHistoricoMocoes(historicoMocoesModel);
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
  final TextEditingController descricaoController;
  final HistoricoMocoesModel historicoMocoesModel;

  const TelaCadastroHistoricoMocoes({
    super.key,
    required this.descricaoController,
    required this.historicoMocoesModel,
  });

  @override
  State<TelaCadastroHistoricoMocoes> createState() =>
      _TelaCadastroMocoesState();
}

class _TelaCadastroMocoesState extends State<TelaCadastroHistoricoMocoes> {
  @override
  void initState() {
    super.initState();
    widget.descricaoController.text = widget.historicoMocoesModel.descricao;
    widget.descricaoController.addListener(() => widget
        .historicoMocoesModel.descricao = widget.descricaoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        child: Form(
          child: Column(
            children: [
              const Text('Histórico'),
              TextFormField(
                maxLines: 10,
                controller: widget.descricaoController,
                decoration: const InputDecoration(
                    hintText: 'Informe o histórico da moção',
                    border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
