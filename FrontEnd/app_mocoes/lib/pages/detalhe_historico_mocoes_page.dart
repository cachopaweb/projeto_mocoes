import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/historico_mocoes_model.dart';
import '../utils/utils.dart';

class DetalheHistoricoMocoesPage extends StatefulWidget {
  final HistoricoMocoesModel historicoMocoesModel;
  const DetalheHistoricoMocoesPage(
      {super.key, required this.historicoMocoesModel});

  @override
  State<DetalheHistoricoMocoesPage> createState() =>
      _DetalheHistoricoMocoesPageState();
}

class _DetalheHistoricoMocoesPageState
    extends State<DetalheHistoricoMocoesPage> {
  _buildSuccess(HistoricoMocoesModel model) {
    final dateFmt = DateFormat('dd/MM/yyyy hh:mm:ss');
    return Container(
      height: 200,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        border: Border.all(
          width: 3,
          color: strToStatus(model.status).StatusToColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.status,
              style: TextStyle(color: strToStatus(model.status).StatusToColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Descrição: \n${model.descricao}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Data Status: ${dateFmt.format(model.dataStatus)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return _buildSuccess(widget.historicoMocoesModel);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
