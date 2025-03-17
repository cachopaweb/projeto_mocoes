// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class Dropdownstatus extends StatefulWidget {
  final void Function(String?)? onChanged;
  const Dropdownstatus({
    super.key,
    required this.onChanged,
  });

  @override
  State<Dropdownstatus> createState() => _DropDownEstadosState();
}

class _DropDownEstadosState extends State<Dropdownstatus> {
  var dropdownValue = '';
  var isLoading = false;
  var isError = false;

  @override
  void initState() {
    super.initState();
    dropdownValue = listaStatus[0];
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
        'Erro ao buscar status!',
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
                  'Selecione o Status',
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
                  items: listaStatus
                      .map(
                        (model) => DropdownMenuItem<String>(
                          alignment: Alignment.center,
                          value: model,
                          child: Text(
                            model,
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
