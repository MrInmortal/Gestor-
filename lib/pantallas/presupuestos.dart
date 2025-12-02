// lib/pantallas/presupuestos.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart'; // Para Id
import '../gestores/gestor_presupuesto.dart';
import '../gestores/servicio_isar.dart'; // Necesario para el nuevo método reactivo
import '../modelos/presupuesto.dart';

// ************************************************
// NUEVO: Provider de Presupuesto Reactivo
// ************************************************
final excedentePresupuestoStreamProvider = StreamProvider.family<double, Presupuesto>((ref, presupuesto) async* {
  final isarService = ref.watch(isarServiceProvider);
  
  // 1. Escucha el stream de gasto real para esta categoría en el mes actual
  final gastoActualStream = isarService.escucharGastoMensualPorCategoria(presupuesto.categoria);

  // 2. Transforma el stream de gasto real en un stream de excedente
  await for (final gastoReal in gastoActualStream) {
    // Calcula el excedente (Límite - Gasto Real)
    yield presupuesto.montoPresupuestado - gastoReal;
  }
});


class PantallaPresupuestos extends ConsumerWidget {
  const PantallaPresupuestos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el stream de presupuestos (reactivo)
    final presupuestosAsync = ref.watch(presupuestosStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos Mensuales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _mostrarDialogoPresupuesto(context, ref, null),
          ),
        ],
      ),
      body: presupuestosAsync.when(
        data: (presupuestos) {
          if (presupuestos.isEmpty) {
            return const Center(
              child: Text('No tienes presupuestos establecidos. ¡Añade uno!'),
            );
          }
          return ListView.builder(
            itemCount: presupuestos.length,
            itemBuilder: (context, index) {
              final p = presupuestos[index];
              return _buildPresupuestoCard(context, ref, p);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar presupuestos: $e')),
      ),
    );
  }

  // Widget para mostrar y administrar un presupuesto individual (ACTUALIZADO para Stream)
  Widget _buildPresupuestoCard(BuildContext context, WidgetRef ref, Presupuesto p) {
    final gestor = ref.read(gestorPresupuestoProvider);
    
    // CAMBIO CLAVE: Observar el StreamProvider reactivo
    final excedenteAsync = ref.watch(excedentePresupuestoStreamProvider(p));
    
    // Renderiza basándose en el stream del excedente
    return excedenteAsync.when(
      loading: () => _buildCardSkeleton(context, p), 
      error: (e, s) => _buildCardSkeleton(context, p, error: true), 
      data: (excedente) {
        final isExceeded = excedente < 0;
        final gastoReal = p.montoPresupuestado - excedente;
        final progress = p.montoPresupuestado > 0 ? gastoReal / p.montoPresupuestado : 0.0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.bar_chart_rounded, color: isExceeded ? Colors.red : Theme.of(context).colorScheme.primary),
            title: Text('${p.categoria}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gasto Actual: \$${gastoReal.toStringAsFixed(2)} / Límite: \$${p.montoPresupuestado.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0), 
                  color: isExceeded ? Colors.red : Colors.green,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  isExceeded 
                    ? '¡Excedido por: \$${(excedente * -1).toStringAsFixed(2)}!'
                    : 'Restante: \$${excedente.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isExceeded ? Colors.red : Colors.green, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _mostrarDialogoPresupuesto(context, ref, p), // Editar
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () => gestor.eliminarPresupuesto(p.isarId), // Eliminar
                ),
              ],
            ),
            onTap: () => _mostrarDialogoPresupuesto(context, ref, p),
          ),
        );
      },
    );
  }

  // Helper para mostrar un esqueleto mientras el stream carga
  Widget _buildCardSkeleton(BuildContext context, Presupuesto p, {bool error = false}) {
      return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
              title: Text(p.categoria),
              subtitle: Text(error ? 'Error de carga' : 'Calculando gasto real...'),
              trailing: error ? const Icon(Icons.error, color: Colors.red) : const CircularProgressIndicator.adaptive(),
          ),
      );
  }

  // Diálogo para Añadir/Editar Presupuesto (Código original, solo requiere Id)
  void _mostrarDialogoPresupuesto(BuildContext context, WidgetRef ref, Presupuesto? presupuesto) {
    final isEditing = presupuesto != null;
    final gestor = ref.read(gestorPresupuestoProvider);
    final formKey = GlobalKey<FormState>();
    
    String categoria = isEditing ? presupuesto.categoria : 'Comida';
    double monto = isEditing ? presupuesto.montoPresupuestado : 0.0;
    
    final List<String> categoriasBase = ['Comida', 'Transporte', 'Salud', 'Hogar', 'Ocio', 'Otros'];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Presupuesto: $categoria' : 'Añadir Nuevo Presupuesto'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selector de Categoría (Deshabilitado si editando)
                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categoriasBase.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )).toList(),
                      onChanged: isEditing ? null : (value) => categoria = value!,
                      validator: (value) => value == null ? 'Seleccione una categoría.' : null,
                    ),
                    const SizedBox(height: 10),
                    // Campo de Monto
                    TextFormField(
                      initialValue: monto > 0 ? monto.toStringAsFixed(2) : '',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Monto Presupuestado (\$)', prefixIcon: Icon(Icons.attach_money)),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Ingrese un monto válido mayor a 0.';
                        }
                        return null;
                      },
                      onSaved: (value) => monto = double.parse(value!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      gestor.guardarPresupuesto(
                        categoria: categoria,
                        monto: monto,
                        id: isEditing ? presupuesto!.isarId : null,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(isEditing ? 'Guardar Cambios' : 'Crear Presupuesto'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}