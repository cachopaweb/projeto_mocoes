import 'dart:developer';

import 'package:flutter/material.dart';

import '../Services/Local_storage.Service.dart';
import '../models/estados_model.dart';
import '../repositories/estados_repository.dart';

class DropDownEstados extends StatefulWidget {
  const DropDownEstados({super.key});

  @override
  State<DropDownEstados> createState() => _DropDownEstadosState();
}

class _DropDownEstadosState extends State<DropDownEstados> {
  var dropdownValue = '';
  var listaEstados = <EstadosModel>[];
  var isLoading = false;
  var isError = false;
  final localStorage = LocalStorageService();
  final repository = EstadosRepository();

  @override
  void initState() {
    super.initState();
    _buscaEstados();
    _buscaEstado();
  }

  _buscaEstados() async {
    try {
      setState(() {
        isLoading = true;
      });
      listaEstados = await repository.fetchEstados();
      if ((listaEstados.isNotEmpty) && (dropdownValue.isEmpty)) {
        setState(() {
          dropdownValue = listaEstados[0].nome;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      listaEstados = [];
      setState(() {
        isError = true;
      });
    }
  }

  _buscaEstado() async {
    try {
      setState(() {
        isLoading = true;
      });
      dropdownValue = await localStorage.get('Estado') ?? '';
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
        'Erro ao buscar Estados!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return dropdownValue.isNotEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Text(
                  'Selecione o Estado',
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
                  items: listaEstados
                      .map(
                        (model) => DropdownMenuItem<String>(
                          alignment: Alignment.center,
                          value: model.nome,
                          child: Text(
                            model.nome,
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
                        final estado = listaEstados
                            .firstWhere((e) => e.nome == dropdownValue);
                        localStorage.put('Estado', estado.nome);
                        localStorage.put('cod_estado', estado.codigo);
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
