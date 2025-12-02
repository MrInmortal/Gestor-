// lib/gestores/gestor_presupuesto.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; 
import '../modelos/presupuesto.dart';
import 'servicio_isar.dart';
import '../modelos/transaccion.dart';

// 1. Provider reactivo para escuchar todos los presupuestos
final presupuestosStreamProvider = StreamProvider<List<Presupuesto>>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return isarService.escucharTodosLosPresupuestos();
});

// 2. Provider para la lógica de presupuesto
final gestorPresupuestoProvider = Provider((ref) {
  final isarService = ref.read(isarServiceProvider);
  return GestorPresupuesto(isarService);
});

class GestorPresupuesto {
  final ServicioIsar _servicioIsar;

  GestorPresupuesto(this._servicioIsar);

  // Lógica para crear o actualizar un presupuesto
  Future<void> guardarPresupuesto({
    required String categoria,
    required double monto,
    Id? id, // Si tiene ID, es una actualización
  }) async {
    Presupuesto? presupuestoExistente;
    
    if (id != null) {
      final isar = await _servicioIsar.db;
      presupuestoExistente = await isar.presupuestos.get(id);
    } 
    else {
      presupuestoExistente = await _servicioIsar.obtenerPresupuestoPorCategoria(categoria);
    }
    
    final nuevoPresupuesto = Presupuesto(
      categoria: categoria,
      montoPresupuestado: monto,
      fechaCreacion: presupuestoExistente?.fechaCreacion ?? DateTime.now(),
    );
    
    if (presupuestoExistente != null) {
        nuevoPresupuesto.isarId = presupuestoExistente.isarId;
    }
    await _servicioIsar.guardarPresupuesto(nuevoPresupuesto);
  }

  // Lógica para eliminar un presupuesto
  Future<void> eliminarPresupuesto(Id id) async {
    await _servicioIsar.eliminarPresupuesto(id);
  }

  // 🚨 CORRECCIÓN CLAVE: Método público para obtener el presupuesto (usado en nueva_transaccion.dart)
  Future<Presupuesto?> obtenerPresupuesto(String categoria) async {
    return _servicioIsar.obtenerPresupuestoPorCategoria(categoria);
  }

  // Función auxiliar para obtener el gasto real en la categoría del mes actual
  // Se usa para calcular cuánto se ha gastado ANTES del nuevo gasto.
  Future<double> obtenerGastoRealActual(String categoria) async {
      final now = DateTime.now();
      // Establece el inicio del mes actual
      final inicioMes = DateTime(now.year, now.month, 1);
      // Establece el final del mes actual
      final finMes = DateTime(now.year, now.month + 1, 1).subtract(const Duration(seconds: 1));
      
      final gastoReal = await _servicioIsar.obtenerTotalesPorCategoriaRango(
        inicioMes, 
        finMes,
        categoria,
      );
      
      return gastoReal;
  }
}