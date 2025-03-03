class EstadosModel {
  final int codigo;
  final String nome;
  final String sigla;
  final int codigoIbge;

  EstadosModel({
    required this.codigo,
    required this.nome,
    required this.sigla,
    required this.codigoIbge,
  });

  // Método para converter um mapa em uma instância de EstadosModel
  factory EstadosModel.fromJson(Map<String, dynamic> json) {
    return EstadosModel(
      codigo: json['codigo'],
      nome: json['nome'],
      sigla: json['sigla'],
      codigoIbge: json['codigo_ibge'],
    );
  }

  // Método para converter uma instância de EstadosModel em um mapa
  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'sigla': sigla,
      'codigo_ibge': codigoIbge,
    };
  }

  factory EstadosModel.fromMap(Map<String, dynamic> map) {
    return EstadosModel(
      codigo: map['codigo']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      codigoIbge: map['codigo_ibge']?.toInt() ?? 0,
    );
  }
}
