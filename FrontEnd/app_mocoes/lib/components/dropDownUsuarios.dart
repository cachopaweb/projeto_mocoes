import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/usuario_model.dart';
import '../Services/Local_storage.Service.dart';
import '../repositories/usuario_repository.dart';

class DropDownUsuarios extends StatefulWidget {
  const DropDownUsuarios({super.key});

  @override
  State<DropDownUsuarios> createState() => _DropDownUsuariosState();
}

class _DropDownUsuariosState extends State<DropDownUsuarios> {
  var dropdownValue = '';
  var listaUsuarios = <UsuarioModel>[];
  var isLoading = false;
  var isError = false;
  final localStorage = LocalStorageService();
  final repository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    _buscaUsuarios();
    _buscaUsuario();
  }

  _buscaUsuarios() async {
    try {
      setState(() {
        isLoading = true;
      });
      listaUsuarios = await repository.fetchUsuario();
      if ((listaUsuarios.isNotEmpty) && (dropdownValue.isEmpty)) {
        setState(() {
          dropdownValue = listaUsuarios[0].login;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      listaUsuarios = [];
      setState(() {
        isError = true;
      });
    }
  }

  _buscaUsuario() async {
    try {
      setState(() {
        isLoading = true;
      });
      dropdownValue = await localStorage.get('usuario') ?? '';
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildLoading()
        : isError
            ? _buildError()
            : _buildSuccess();
  }

  _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError() {
    return const Center(
      child: Text(
        'Erro ao buscar Usuarios!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return dropdownValue.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Usuários',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  elevation: 14,
                  alignment: Alignment.center,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: listaUsuarios
                      .map(
                        (model) => DropdownMenuItem<String>(
                          alignment: Alignment.center,
                          value: model.login,
                          child: Text(
                            model.login,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownValue = newValue!;
                        localStorage.put('usuario', dropdownValue);
                      },
                    );
                  },
                ),
              ],
            ),
          )
        : _buildLoading();
  }
}
