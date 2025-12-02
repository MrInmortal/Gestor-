// lib/modelos/presupuesto.dart
import 'package:isar/isar.dart';

part 'presupuesto.g.dart'; // Se genera automáticamente.

@Collection()
class Presupuesto {
  Id isarId = Isar.autoIncrement;
  
  @Index(unique: true) // Asegura que solo haya un presupuesto por categoría
  late String categoria; 
  
  late double montoPresupuestado;
  late DateTime fechaCreacion;
  
  // Puedes añadir el mes/año al que aplica si quieres presupuestos recurrentes

  Presupuesto({
    required this.categoria,
    required this.montoPresupuestado,
    required this.fechaCreacion,
  });
}