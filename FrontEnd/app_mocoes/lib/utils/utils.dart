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
