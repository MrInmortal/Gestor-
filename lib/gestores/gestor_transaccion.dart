// lib/gestores/gestor_transaccion.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Necesario para el tipo Id
import '../modelos/transaccion.dart';
import 'servicio_isar.dart';

// --- PROVIDERS ---

// 1. Provider que expone la lista de transacciones usando Stream (reactivo)
final transaccionesStreamProvider = StreamProvider<List<Transaccion>>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  // Asumo que ServicioIsar.escucharTodasLasTransacciones() existe
  return isarService.escucharTodasLasTransacciones(); 
});

// 2. Provider para la lógica de negocio (CRUD)
final gestorTransaccionProvider = Provider((ref) {
  final isarService = ref.read(isarServiceProvider);
  return GestorTransaccion(isarService);
});

// --- LÓGICA DE NEGOCIO ---

class GestorTransaccion {
  final ServicioIsar _servicioIsar;

  GestorTransaccion(this._servicioIsar);

  // Lógica para guardar o actualizar una transacción existente.
  // Si transaccion.isarId ya existe, Isar lo actualizará.
  Future<void> guardarTransaccion(Transaccion transaccion) async {
    await _servicioIsar.guardarTransaccion(transaccion);
  }

  // Lógica para crear una nueva transacción (usado cuando no se pasa un objeto completo).
  // Es un helper que crea el objeto y llama a guardarTransaccion.
  Future<void> agregarTransaccion({
    required String categoria,
    required double monto,
    required String descripcion,
    required bool esGasto,
  }) async {
    final nuevaTransaccion = Transaccion(
      // Isar asignará un nuevo ID automáticamente
      categoria: categoria,
      monto: monto,
      fecha: DateTime.now(),
      descripcion: descripcion,
      esGasto: esGasto,
    );
    await _servicioIsar.guardarTransaccion(nuevaTransaccion);
  }

  // Lógica para eliminar una transacción por su ID.
  Future<void> eliminarTransaccion(Id id) async {
    await _servicioIsar.eliminarTransaccion(id);
  }
}