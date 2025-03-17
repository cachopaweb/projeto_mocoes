import 'dart:developer';

import 'package:app_mocoes/models/cidades_model.dart';
import 'package:flutter/material.dart';

import '../Services/Local_storage.Service.dart';
import '../models/vereadores_model.dart';
import '../repositories/vereadores_repository.dart';

class Dropdownvereadores extends StatefulWidget {
  final CidadesModel cidadesModel;
  final int codEstado;
  final void Function(String?)? onChanged;
  const Dropdownvereadores({
    super.key,
    required this.cidadesModel,
    required this.codEstado,
    required this.onChanged,
  });

  @override
  State<Dropdownvereadores> createState() => _DropdownvereadoresState();
}

class _DropdownvereadoresState extends State<Dropdownvereadores> {
  var dropdownValue = ValueNotifier('');
  var listaVereadores = <VereadoresModel>[];
  var isLoading = false;
  var isError = false;
  final localStorage = LocalStorageService();
  final repository = VereadoresRepository();

  @override
  void initState() {
    super.initState();
    _buscavereadores();
    dropdownValue.addListener(() {
      setState(() {});
    });
  }

  _buscavereadores() async {
    try {
      setState(() {
        isLoading = true;
      });
      listaVereadores = await repository.fetchVereadores(
          widget.codEstado, widget.cidadesModel);
      if ((listaVereadores.isNotEmpty) && (dropdownValue.value.isEmpty)) {
        setState(() {
          dropdownValue.value = listaVereadores[0].nome;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      listaVereadores = [];
      setState(() {
        isError = true;
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
        'Erro ao buscar vereadores!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return dropdownValue.value.isNotEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Text(
                  'Selecione o Vereador',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue.value,
                  elevation: 14,
                  alignment: Alignment.center,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: listaVereadores
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
                  onChanged: widget.onChanged,
                ),
              ],
            ),
          )
        : _buildLoading();
  }
}
