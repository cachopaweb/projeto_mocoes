// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VereadoresModel {
  final int codigo;
  final String nome;
  final int? classificacao;
  final int? classificacaoTse;
  final String? coligacao;
  final String? eleito;
  final String foto;
  final String? partido;
  final String? urlCandidato;
  final String? votos;

  VereadoresModel(
      {required this.codigo,
      required this.nome,
      this.classificacao,
      this.classificacaoTse,
      this.coligacao,
      this.eleito,
      required this.foto,
      this.partido,
      this.urlCandidato,
      this.votos});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'nome': nome,
      'classificacao': classificacao,
      'classificacaoTse': classificacaoTse,
      'coligacao': coligacao,
      'eleito': eleito,
      'foto': foto,
      'partido': partido,
      'urlCandidato': urlCandidato,
      'votos': votos,
    };
  }

  factory VereadoresModel.fromMap(Map<String, dynamic> map) {
    return VereadoresModel(
      codigo: map['codigo'] as int,
      nome: map['nome'] as String,
      classificacao:
          map['classificacao'] != null ? map['classificacao'] as int : null,
      classificacaoTse: map['classificacaoTse'] != null
          ? map['classificacaoTse'] as int
          : null,
      coligacao: map['coligacao'] != null ? map['coligacao'] as String : null,
      eleito: map['eleito'] != null ? map['eleito'] as String : null,
      foto: map['foto'] as String,
      partido: map['partido'] != null ? map['partido'] as String : null,
      urlCandidato:
          map['urlCandidato'] != null ? map['urlCandidato'] as String : null,
      votos: map['votos'] != null ? map['votos'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VereadoresModel.fromJson(String source) =>
      VereadoresModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory VereadoresModel.empty() =>
      VereadoresModel(codigo: 0, nome: '', foto: '');
}
