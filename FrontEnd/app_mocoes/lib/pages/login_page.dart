import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/dropDownEstados.dart';
import '../controllers/usuario_controller.dart';
import '../services/Local_storage.Service.dart';
import 'mocoes_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final localStorage = LocalStorageService();
  final controllerSenha = TextEditingController();
  final controllerUsuario = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _carregaDadosLocalStorage();
  }

  _carregaDadosLocalStorage() async {
    try {
      controllerUsuario.text = await localStorage.get('usuario');
      controllerSenha.text = await localStorage.get('senha');
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const DropDownEstados(),
                TextFormField(
                  controller: controllerUsuario,
                  decoration: const InputDecoration(
                    hintText: 'Usuário',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O usuário é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: controllerSenha,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A senha é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildButtonAcessar(context, _formKey),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAcessar(
      BuildContext context, GlobalKey<FormState> formKey) {
    return SizedBox(
      height: 47,
      child: ElevatedButton(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Acessar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        onPressed: () async {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logando no sistema...')),
          );
          if (_formKey.currentState!.validate()) {
            try {
              final usuarioController =
                  Provider.of<UsuarioController>(context, listen: false);
              if (await usuarioController.logar(
                  controllerUsuario.text, controllerSenha.text)) {
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const MocoesPage(),
                  ),
                );
                localStorage.put('usuario', controllerUsuario.text);
                localStorage.put('senha', controllerSenha.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Usuario ou senha incorretos...')),
                );
              }
            } catch (e) {
              log(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Erro ao tentar Logar.',
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
