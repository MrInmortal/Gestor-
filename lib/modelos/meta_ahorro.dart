// lib/modelos/meta_ahorro.dart
import 'package:isar/isar.dart';

part 'meta_ahorro.g.dart'; // Isar generará este archivo

@Collection()
class MetaAhorro {
  Id isarId = Isar.autoIncrement;

  late String nombre; // Ej: Vacaciones en Cancún
  late double montoObjetivo; // El total que se quiere ahorrar
  late double montoAhorrado; // Lo que se ha acumulado hasta ahora
  late DateTime fechaLimite; // Fecha esperada de cumplimiento
  late DateTime fechaCreacion;

  // Constructor por defecto
  MetaAhorro({
    this.montoAhorrado = 0.0,
  });
}