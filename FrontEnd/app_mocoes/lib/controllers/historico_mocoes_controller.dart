import 'package:flutter/material.dart';

import '../models/vereadores_model.dart';
import '../utils/utils.dart';

class HistoricoMocoesController extends ChangeNotifier {
  var _vereador = VereadoresModel.empty();
  var _descricao = '';
  var _status = Status.semContato;
  var _dataStatus = DateTime.now();

  void setVereador(VereadoresModel model) {
    _vereador = model;
    notifyListeners();
  }

  void setStatus(Status st) {
    _status = st;
    notifyListeners();
  }

  void setDataStatus(DateTime dtStatus) {
    _dataStatus = dtStatus;
    notifyListeners();
  }

  void setDescricao(String descricao) {
    _descricao = descricao;
    notifyListeners();
  }

  VereadoresModel getVereador() => _vereador;
  Status getStatus() => _status;
  DateTime getDataStatus() => _dataStatus;
  String getDescricao() => _descricao;
}
