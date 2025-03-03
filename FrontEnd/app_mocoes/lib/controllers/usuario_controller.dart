import 'package:flutter/cupertino.dart';

import '../Models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../services/Local_storage.Service.dart';

class UsuarioController extends ChangeNotifier {
  final repository = UsuarioRepository();
  final localStorage = LocalStorageService();
  late UsuarioModel usuarioLogado;

  Future<bool> logar(String login, String senha) async {
    try {
      usuarioLogado = await repository.fetchLogin(login, senha);
      final estado = await localStorage.get('cod_estado');
      usuarioLogado.estadoEscolhido = estado != null ? estado as int : 0;
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
