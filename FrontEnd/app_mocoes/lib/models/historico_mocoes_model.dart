import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HistoricoMocoesModel {
  final int codigo;
  final int codMocao;
  final int codVereador;
  final String descricao;
  final DateTime dataCriacao;
  final int codUsuario;
  final String status;
  final DateTime dataStatus;

  HistoricoMocoesModel({
    required this.codigo,
    required this.codMocao,
    required this.codVereador,
    required this.descricao,
    required this.dataCriacao,
    required this.codUsuario,
    required this.status,
    required this.dataStatus,
  });

  set descricao(String value) => descricao = value;
  set codigo(int value) => codigo = value;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'codMocao': codMocao,
      'codVereador': codVereador,
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
      'codUsuario': codUsuario,
      'status': status,
      'dataStatus': dataStatus.toIso8601String(),
    };
  }

  factory HistoricoMocoesModel.fromMap(Map<String, dynamic> map) {
    return HistoricoMocoesModel(
      codigo: map['codigo'] as int,
      codMocao: map['codMocao'] as int,
      codVereador: map['codVereador'] as int,
      descricao: map['descricao'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao']),
      codUsuario: map['codUsuario'] as int,
      status: map['status'] as String,
      dataStatus: DateTime.parse(map['dataStatus']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoricoMocoesModel.fromJson(String source) =>
      HistoricoMocoesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory HistoricoMocoesModel.empty() => HistoricoMocoesModel(
      codigo: 0,
      codMocao: 0,
      codVereador: 0,
      descricao: '',
      dataCriacao: DateTime.timestamp(),
      codUsuario: 0,
      status: 'Sem Contato',
      dataStatus: DateTime.now());
}
