import 'package:dio/dio.dart';

import '../models/cidades_model.dart';
import 'options_dio.dart';

class CidadesRepository {
  Future<List<CidadesModel>> fetchCidades(int estado) async {
    if (estado == 0) return throw Exception('Estado não informado!');
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.get('/cidades?estado=$estado');
      final list = response.data as List;
      return list.map((e) => CidadesModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
