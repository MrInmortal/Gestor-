// lib/gestores/servicio_isar.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart'; // Necesario para Rx.merge

import '../modelos/transaccion.dart';
import '../modelos/presupuesto.dart';
import '../modelos/meta_ahorro.dart'; 

final isarServiceProvider = Provider<ServicioIsar>((ref) => ServicioIsar());

class ServicioIsar {
  late Future<Isar> db;

  ServicioIsar() {
    db = _abrirIsar();
  }

  // --- MÉTODOS DE CONFIGURACIÓN ---
  Future<Isar> _abrirIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    
    if (Isar.instanceNames.isEmpty) {
      // Incluir MetaAhorroSchema
      return Isar.open(
        [TransaccionSchema, PresupuestoSchema, MetaAhorroSchema], 
        directory: dir.path,
        inspector: true, 
      );
    }
    return Future.value(Isar.getInstance());
  }

  // --- MÉTODOS CRUD DE TRANSACCIONES ---
  
  // Guardar (Crear/Actualizar)
  Future<void> guardarTransaccion(Transaccion transaccion) async {
    final isar = await db;
    
    // Lógica para actualizar el montoAhorrado de la meta al registrar un ingreso
    if (!transaccion.esGasto && transaccion.metaId != null) {
        // Usamos int para la metaId
        await _actualizarMontoMeta(isar, transaccion.metaId!, transaccion.monto);
    }
    
    await isar.writeTxn(() => isar.transaccions.put(transaccion));
  }
  
  Stream<List<Transaccion>> escucharTodasLasTransacciones() async* {
    final isar = await db;
    yield* isar.transaccions
        .where()
        .sortByFechaDesc() 
        .watch(fireImmediately: true); 
  }
  
  // Cálculo del Saldo Total Global (Excluye ingresos destinados a metas)
  Stream<double> escucharSaldoTotal() async* {
    final isar = await db;
    
    // Escuchar cambios en Transacciones y Metas para asegurar reactividad
    final txsStream = isar.transaccions.where().watch(fireImmediately: true);
    final metasStream = isar.metaAhorros.where().watch(fireImmediately: true); 
    
    // Combinamos ambos streams
    await for (final _ in Rx.merge([txsStream, metasStream])) {
      final txs = await isar.transaccions.where().findAll();
      
      double saldoTotal = 0;
      
      for (var tx in txs) {
        // Si es un ingreso destinado a una meta, lo ignoramos para el saldo general
        if (!tx.esGasto && tx.metaId != null) {
            continue; 
        }
        
        if (tx.esGasto) {
          saldoTotal -= tx.monto;
        } else {
          saldoTotal += tx.monto; 
        }
      }
      yield saldoTotal;
    }
  }

  // Helper para actualizar el monto de la meta (usado al guardar/editar/eliminar una Transaccion)
  Future<void> _actualizarMontoMeta(Isar isar, int metaId, double monto) async {
      await isar.writeTxn(() async {
          final meta = await isar.metaAhorros.get(metaId); 
          if (meta != null) {
              meta.montoAhorrado += monto; // Suma o resta el monto
              await isar.metaAhorros.put(meta);
          }
      });
  }
  
  Future<void> eliminarTransaccion(Id id) async {
    final isar = await db;
    // Debemos leer la transacción ANTES de eliminarla para saber a qué meta afecta
    final tx = await isar.transaccions.get(id);

    // Revertir el monto de la meta si la transacción eliminada era un ingreso destinado a una meta
    if (tx != null && !tx.esGasto && tx.metaId != null) {
        // Restamos el monto
        await _actualizarMontoMeta(isar, tx.metaId!, -tx.monto); 
    }

    await isar.writeTxn(() => isar.transaccions.delete(id));
  }
  
  // Obtener una lista completa y NO reactiva (usado en informes/CSV)
  Future<List<Transaccion>> obtenerTodasLasTransacciones() async {
    final isar = await db;
    return isar.transaccions.where().findAll(); 
  }
  
  // --- CONSULTA AVANZADA (Actualizada con método reactivo para Presupuestos) ---
  
  // NUEVO: Método para observar el gasto total de una categoría en el mes actual (REACTIVO para Presupuestos)
  Stream<double> escucharGastoMensualPorCategoria(String categoria) async* {
    final isar = await db;
    final now = DateTime.now();
    final inicioMes = DateTime(now.year, now.month, 1);
    final finMes = DateTime(now.year, now.month + 1, 1).subtract(const Duration(seconds: 1));
    
    // Observa los cambios en transacciones y calcula el total
    yield* isar.transaccions
        .filter()
        .fechaBetween(inicioMes, finMes) // Filtra por el mes actual
        .esGastoEqualTo(true)            // Solo gastos
        .categoriaEqualTo(categoria)     // Solo la categoría de interés
        .watch(fireImmediately: true)
        .map((gastos) {
            double total = 0;
            for (final gasto in gastos) {
                total += gasto.monto;
            }
            return total;
        });
  }
  
  // Método no reactivo para validación/cálculo
  Future<double> obtenerTotalesPorCategoriaRango(
      DateTime inicio, 
      DateTime fin,
      String categoria, 
  ) async {
    final isar = await db;
    
    final gastos = await isar.transaccions
        .filter()
        .fechaBetween(inicio, fin)
        .esGastoEqualTo(true)
        .categoriaEqualTo(categoria) 
        .findAll();
        
    double total = 0.0;
    for (final gasto in gastos) {
      total += gasto.monto;
    }
    return total;
  }
  
  // --- MÉTODOS CRUD DE PRESUPUESTOS (Se mantienen igual) ---
  
  Future<void> guardarPresupuesto(Presupuesto presupuesto) async {
    final isar = await db;
    await isar.writeTxn(() => isar.presupuestos.put(presupuesto));
  }
  Stream<List<Presupuesto>> escucharTodosLosPresupuestos() async* {
    final isar = await db;
    yield* isar.presupuestos.where().watch(fireImmediately: true); 
  }
  Future<Presupuesto?> obtenerPresupuestoPorCategoria(String categoria) async {
    final isar = await db;
    return isar.presupuestos.filter().categoriaEqualTo(categoria).findFirst();
  }
  Future<void> eliminarPresupuesto(Id id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.presupuestos.delete(id));
  }
  
  // --- MÉTODOS CRUD DE METAS ---

  Future<void> guardarMeta(MetaAhorro meta) async {
    final isar = await db;
    await isar.writeTxn(() => isar.metaAhorros.put(meta));
  }
  
  // Método reactivo que escucha cambios en Metas Y Transacciones
  Stream<List<MetaAhorro>> escucharTodasLasMetas() async* {
    final isar = await db;
    
    final metasStream = isar.metaAhorros.where().watch(fireImmediately: true);
    final txsStream = isar.transaccions.where().watch(fireImmediately: true);
    
    // Combinar ambos streams para forzar la actualización de la lista de metas
    await for (final _ in Rx.merge([metasStream, txsStream])) {
        final metas = await isar.metaAhorros.where().findAll();
        yield metas;
    }
  }

  Future<void> eliminarMeta(Id id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.metaAhorros.delete(id));
  }
}