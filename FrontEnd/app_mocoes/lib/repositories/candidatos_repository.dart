import 'package:dio/dio.dart';

import '../models/candidatos_model.dart';
import '../models/cidades_model.dart';
import '../utils/utils.dart';
import 'options_dio.dart';

class CandidatosRepository {
  Future<List<CandidatosModel>> fetchCandidatos(
      int estado, CidadesModel cidade) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      //normalize cidade
      final cidadeNormalizada = normalizeCityName(cidade.nome);
      //busca o estado
      final response = await dio.get(
          '/candidatos?estado=${cidade.uf.toLowerCase()}&cidadeDescricao=$cidadeNormalizada&codCidade=${cidade.codigo}');
      final lista = response.data as List;
      final listaCandidatos =
          lista.map((c) => CandidatosModel.fromMap(c)).toList();
      return listaCandidatos.where((e) => e.eleito!.contains('s')).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
