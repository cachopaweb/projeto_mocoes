import 'dart:convert';

import '../utils/utils.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CidadesModel {
  int codigo;
  String uf;
  int codigoIbge;
  int est;
  String nome;
  String status;

  CidadesModel({
    required this.codigo,
    required this.uf,
    required this.codigoIbge,
    required this.est,
    required this.nome,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'uf': uf,
      'codigo_ibge': codigoIbge,
      'est': est,
      'nome': nome,
      'status': status,
    };
  }

  factory CidadesModel.fromMap(Map<String, dynamic> map) {
    return CidadesModel(
      codigo: map['codigo'] as int,
      uf: map['uf'] as String,
      codigoIbge: map['codigo_ibge'] as int,
      est: map['est'] as int,
      nome: map['nome'] as String,
      status: ((map['status'] != null && (map['status']).isNotEmpty)
          ? map['status']
          : Status.semContato.StatusToStr) as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CidadesModel.fromJson(String source) =>
      CidadesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
