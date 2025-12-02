// lib/gestores/gestor_meta.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; // Importar Isar para Id
import '../modelos/meta_ahorro.dart';
import 'servicio_isar.dart';

// Provider para exponer el gestor
final gestorMetaProvider = Provider((ref) => GestorMeta(ref.read(isarServiceProvider)));

// Provider reactivo para escuchar todas las metas (CRÍTICO para la lista)
final metasStreamProvider = StreamProvider<List<MetaAhorro>>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return isarService.escucharTodasLasMetas();
});

class GestorMeta {
  final ServicioIsar _isarService;

  GestorMeta(this._isarService);

  // --- MÉTODOS CRUD ---
  Future<void> guardarMeta({
    required String nombre,
    required double montoObjetivo,
    required DateTime fechaLimite,
    Id? id,
    double montoAhorrado = 0.0, // Solo se pasa al editar
  }) async {
    // Si estamos editando, cargamos la meta existente para mantener el montoAhorrado
    MetaAhorro? metaExistente;
    if (id != null) {
      final isar = await _isarService.db;
      metaExistente = await isar.metaAhorros.get(id);
    }

    final meta = MetaAhorro(
        montoAhorrado: metaExistente?.montoAhorrado ?? montoAhorrado,
    )
      ..isarId = id ?? Isar.autoIncrement
      ..nombre = nombre
      ..montoObjetivo = montoObjetivo
      ..fechaLimite = fechaLimite
      ..fechaCreacion = metaExistente?.fechaCreacion ?? DateTime.now();

    await _isarService.guardarMeta(meta);
  }

  Future<void> eliminarMeta(Id id) async {
    await _isarService.eliminarMeta(id);
  }
}