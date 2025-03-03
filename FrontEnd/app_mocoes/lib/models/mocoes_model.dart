// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MocoesModel {
  final int codigo;
  final String nome;
  final DateTime dataCriacao;

  MocoesModel({
    required this.codigo,
    required this.nome,
    required this.dataCriacao,
  });

  set nome(String value) {
    nome = value;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'nome': nome,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  factory MocoesModel.fromMap(Map<String, dynamic> map) {
    return MocoesModel(
      codigo: map['codigo'] as int,
      nome: map['nome'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MocoesModel.fromJson(String source) =>
      MocoesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MocoesModel.empty() =>
      MocoesModel(codigo: 0, nome: '', dataCriacao: DateTime(1, 1, 1900));
}
