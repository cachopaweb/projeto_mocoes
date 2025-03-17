import 'package:flutter/material.dart';

String normalizeCityName(String cityName) {
  // Remove accents and convert to lowercase
  String normalized = cityName.toLowerCase();
  normalized = normalized
      .replaceAll(RegExp(r'[áàâãäå]'), 'a')
      .replaceAll(RegExp(r'[éèêë]'), 'e')
      .replaceAll(RegExp(r'[íìîï]'), 'i')
      .replaceAll(RegExp(r'[óòôõö]'), 'o')
      .replaceAll(RegExp(r'[úùûü]'), 'u')
      .replaceAll(RegExp(r'[ç]'), 'c')
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '');

  // Replace spaces with hyphens
  normalized = normalized.replaceAll(' ', '-');

  return normalized;
}

enum Status {
  semContato,
  contatoInicial,
  agendarRetorno,
  reuniaoInicialMarcada,
  agendarMarcarVotacao,
  votacaoMarcada,
  aprovada
}

Status strToStatus(String value) {
  switch (value) {
    case 'SEM CONTATO':
      return Status.semContato;
    case 'CONTATO INICIAL':
      return Status.contatoInicial;
    case 'AG. RETORNO':
      return Status.agendarRetorno;
    case 'REUNIÃO INICIAL MARCADA':
      return Status.reuniaoInicialMarcada;
    case 'AG. MARCAR VOTAÇÃO':
      return Status.agendarMarcarVotacao;
    case 'VOTAÇÃO MARCADA':
      return Status.votacaoMarcada;
    case 'APROVADA':
      return Status.aprovada;
    default:
      return Status.semContato;
  }
}

List<String> listaStatus = [
  'SEM CONTATO',
  'CONTATO INICIAL',
  'AG. RETORNO',
  'REUNIÃO INICIAL MARCADA',
  'AG. MARCAR VOTAÇÃO',
  'VOTAÇÃO MARCADA',
  'APROVADA'
];

extension StatusExtension on Status {
  String get StatusToStr {
    switch (this) {
      case Status.semContato:
        return 'SEM CONTATO';
      case Status.contatoInicial:
        return 'CONTATO INICIAL';
      case Status.agendarRetorno:
        return 'AG. RETORNO';
      case Status.reuniaoInicialMarcada:
        return 'REUNIÃO INICIAL MARCADA';
      case Status.agendarMarcarVotacao:
        return 'AG. MARCAR VOTAÇÃO';
      case Status.votacaoMarcada:
        return 'VOTAÇÃO MARCADA';
      case Status.aprovada:
        return 'APROVADA';
      default:
        return 'SEM CONTATO';
    }
  }

  MaterialColor get StatusToColor {
    switch (this) {
      case Status.semContato:
        return Colors.grey;
      case Status.contatoInicial:
        return Colors.blue;
      case Status.agendarRetorno:
        return Colors.brown;
      case Status.reuniaoInicialMarcada:
        return Colors.cyan;
      case Status.agendarMarcarVotacao:
        return Colors.deepOrange;
      case Status.votacaoMarcada:
        return Colors.indigo;
      case Status.aprovada:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
