import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HistoricoMocoesModel {
  final int codigo;
  final int codMocao;
  final int codCandidato;
  final String descricao;
  final DateTime dataCriacao;
  final int codUsuario;

  HistoricoMocoesModel({
    required this.codigo,
    required this.codMocao,
    required this.codCandidato,
    required this.descricao,
    required this.dataCriacao,
    required this.codUsuario,
  });

  set descricao(String value) => descricao = value;
  set codigo(int value) => codigo = value;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'codMocao': codMocao,
      'codCandidato': codCandidato,
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
      'codUsuario': codUsuario,
    };
  }

  factory HistoricoMocoesModel.fromMap(Map<String, dynamic> map) {
    return HistoricoMocoesModel(
      codigo: map['codigo'] as int,
      codMocao: map['codMocao'] as int,
      codCandidato: map['codCandidato'] as int,
      descricao: map['descricao'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao']),
      codUsuario: map['codUsuario'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoricoMocoesModel.fromJson(String source) =>
      HistoricoMocoesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory HistoricoMocoesModel.empty() => HistoricoMocoesModel(
      codigo: 0,
      codMocao: 0,
      codCandidato: 0,
      descricao: '',
      dataCriacao: DateTime.timestamp(),
      codUsuario: 0);
}
