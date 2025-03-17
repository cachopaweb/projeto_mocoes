import 'package:dio/dio.dart';

import '../models/vereadores_model.dart';
import '../models/cidades_model.dart';
import '../utils/utils.dart';
import 'options_dio.dart';

class VereadoresRepository {
  Future<List<VereadoresModel>> fetchVereadores(
      int estado, CidadesModel cidade) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      //normalize cidade
      final cidadeNormalizada = normalizeCityName(cidade.nome);
      //busca o vereador
      final response = await dio.get(
          '/vereadores?estado=${cidade.uf.toLowerCase()}&cidadeDescricao=$cidadeNormalizada&codCidade=${cidade.codigo}');
      final lista = response.data as List;
      final listavereadores =
          lista.map((c) => VereadoresModel.fromMap(c)).toList();
      return listavereadores.where((e) => e.eleito!.contains('s')).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<VereadoresModel> fetchVereador(int codVereador) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.get('/vereadores/$codVereador');
      return VereadoresModel.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(e);
    }
  }
}
