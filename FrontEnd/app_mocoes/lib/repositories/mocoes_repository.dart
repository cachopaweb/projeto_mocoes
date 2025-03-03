import 'package:dio/dio.dart';

import '../models/mocoes_model.dart';
import 'options_dio.dart';

class MocoesRepository {
  Future<List<MocoesModel>> fetchMocoes() async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.get('/mocoes');
      final lista = response.data as List;
      return lista.map((e) => MocoesModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> createMocoes(MocoesModel mocao) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.post('/mocoes', data: mocao.toMap());
      return response.statusCode == 200;
    } catch (e) {
      throw Exception(e);
    }
  }
}
