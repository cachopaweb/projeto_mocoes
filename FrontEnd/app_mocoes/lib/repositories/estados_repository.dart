import 'package:dio/dio.dart';

import '../models/estados_model.dart';
import 'options_dio.dart';

class EstadosRepository {
  Future<List<EstadosModel>> fetchEstados() async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.get('/estados');
      final list = response.data as List;
      return list.map((e) => EstadosModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
