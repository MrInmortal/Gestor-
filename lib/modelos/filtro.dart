// lib/modelos/filtro.dart
class FiltroEstado {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? categoria; 

  FiltroEstado({
    this.fechaInicio,
    this.fechaFin,
    this.categoria,
  });

  FiltroEstado copyWith({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? categoria,
  }) {
    return FiltroEstado(
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      categoria: categoria ?? this.categoria,
    );
  }
}