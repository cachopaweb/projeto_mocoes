import 'package:app_mocoes/repositories/estados_repository.dart';
import 'package:app_mocoes/utils/utils.dart';
import 'package:dio/dio.dart';

import '../models/candidatos_model.dart';
import 'options_dio.dart';

class CandidatosRepository {
  Future<List<CandidatosModel>> fetchCandidatos(
      int estado, String cidade) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      //normalize cidade
      final cidadeNormalizada = normalizeCityName(cidade);
      //busca o estado
      final repositoryEstado = EstadosRepository();
      final listaEstados = await repositoryEstado.fetchEstados();
      final estadoModel = listaEstados.firstWhere((e) => e.codigo == estado);
      final response = await dio.get(
          '/candidatos?estado=${estadoModel.sigla.toLowerCase()}&cidade=$cidadeNormalizada');
      final lista = response.data as List;
      final listaCandidatos =
          lista.map((c) => CandidatosModel.fromMap(c)).toList();
      return listaCandidatos.where((e) => e.eleito!.contains('s')).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
