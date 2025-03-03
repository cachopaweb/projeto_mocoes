// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_mocoes/models/mocoes_model.dart';
import 'package:intl/intl.dart';

import '../repositories/mocoes_repository.dart';

class TelaCadastroMocoes extends StatefulWidget {
  final TextEditingController descricaoController;
  final MocoesModel mocoesModel;

  const TelaCadastroMocoes({
    super.key,
    required this.descricaoController,
    required this.mocoesModel,
  });

  @override
  State<TelaCadastroMocoes> createState() => _TelaCadastroMocoesState();
}

class _TelaCadastroMocoesState extends State<TelaCadastroMocoes> {
  @override
  void initState() {
    super.initState();
    widget.descricaoController.text = widget.mocoesModel.nome;
    widget.descricaoController.addListener(
        () => widget.mocoesModel.nome = widget.descricaoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        child: Form(
          child: Column(
            children: [
              const Text('Descrição'),
              TextFormField(
                maxLines: 10,
                controller: widget.descricaoController,
                decoration: const InputDecoration(
                    hintText: 'Informe a descrição da moção',
                    border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MocoesPage extends StatefulWidget {
  const MocoesPage({super.key});

  @override
  State<MocoesPage> createState() => _MocoesPageState();
}

class _MocoesPageState extends State<MocoesPage> {
  final respository = MocoesRepository();

  final descricaoController = TextEditingController();

  _buildSuccess(List<MocoesModel> lista) {
    final fmt = DateFormat('dd/MM/yyyy hh:mm:ss');
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed('/cidades', arguments: lista[index]),
          child: Card(
            elevation: 15,
            child: ListTile(
              subtitle: Text(
                fmt.format(lista[index].dataCriacao),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(lista[index].nome),
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
      child: Text('Erro ao buscar moções!\n$error'),
    );
  }

  Future<bool> _buildModalCadastroMocoes(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastro de Moções'),
          content: TelaCadastroMocoes(
            mocoesModel: MocoesModel.empty(),
            descricaoController: descricaoController,
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
      future: respository.fetchMocoes(),
      builder: (context, snapshot) => switch (snapshot) {
        (AsyncSnapshot<List<MocoesModel>> result) when result.hasData =>
          _buildSuccess(result.data!),
        (AsyncSnapshot<List<MocoesModel>> result) when !result.hasError =>
          _buildLoading(),
        (_) => _buildError('Nada encontrado...'),
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
        title: const Text('Moções'),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _buildModalCadastroMocoes(context);
          final listaMocoes = await respository.fetchMocoes();
          if (result) {
            final mocaoModel = MocoesModel(
              codigo: listaMocoes.length + 1,
              nome: descricaoController.text,
              dataCriacao: DateTime.now(),
            );
            final resultInsereMocao =
                await respository.createMocoes(mocaoModel);
            if (resultInsereMocao) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                _buildShowMessage('Moção criada com sucesso', context);
                setState(() {});
              }
            }
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
