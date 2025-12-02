// lib/modelos/transaccion.dart
import 'package:isar/isar.dart';

part 'transaccion.g.dart'; 

@Collection()
class Transaccion {
  // 1. ID ÚNICO (Debe ser el único campo "Id")
  Id isarId = Isar.autoIncrement;

  // 2. DATOS ESENCIALES DE LA TRANSACCIÓN
  @Index(type: IndexType.value) 
  late String categoria; 
  
  late double monto;
  late DateTime fecha;
  late String descripcion;
  late bool esGasto; // true para gasto, false para ingreso

  // 3. NUEVO CAMPO: ID de la meta de ahorro afectada (Usamos int? para evitar el conflicto "Id")
  int? metaId; 

  // Constructor restaurado
  Transaccion({
    this.isarId = Isar.autoIncrement, 
    required this.categoria,
    required this.monto,
    required this.fecha,
    required this.descripcion,
    required this.esGasto,
    this.metaId, // Acepta metaId en el constructor
  });
}