import 'package:app_mocoes/repositories/options_dio.dart';
import 'package:dio/dio.dart';

import '../Models/usuario_model.dart';
import '../controllers/config.Controller.dart';

class UsuarioRepository {
  Future<List<UsuarioModel>> fetchUsuario() async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.get('/usuarios');
      final list = response.data as List;
      return list.map((e) => UsuarioModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UsuarioModel> fetchLogin(String login, String senha) async {
    final options = OptionsDio();
    Dio dio = Dio(await options.getOptions());
    try {
      final response = await dio.post('/login', data: {
        'login': login,
        'senha': senha,
      });
      if (response.statusCode == 200) {
        return UsuarioModel.fromMap(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Usuario não autorizado');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
