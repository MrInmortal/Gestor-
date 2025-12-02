// lib/modelos/configuracion.dart

class ConfiguracionModel {
  final bool esModoOscuro;
  final String idiomaCodigo; // 'es', 'en', 'pt'

  const ConfiguracionModel({
    required this.esModoOscuro,
    required this.idiomaCodigo,
  });

  // Método necesario para que Riverpod y el Gestor puedan actualizar el estado
  ConfiguracionModel copyWith({
    bool? esModoOscuro,
    String? idiomaCodigo,
  }) {
    return ConfiguracionModel(
      esModoOscuro: esModoOscuro ?? this.esModoOscuro,
      idiomaCodigo: idiomaCodigo ?? this.idiomaCodigo,
    );
  }
}