// lib/pantallas/metas.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart'; // Necesario para Id
import '../gestores/gestor_meta.dart';
import '../modelos/meta_ahorro.dart';

class PantallaMetas extends ConsumerWidget {
  const PantallaMetas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el stream de metas (reactivo)
    final metasAsync = ref.watch(metasStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas de Ahorro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => _mostrarDialogoMeta(context, ref, null),
          ),
        ],
      ),
      body: metasAsync.when(
        data: (metas) {
          if (metas.isEmpty) {
            return const Center(
              child: Text('No has creado ninguna meta de ahorro. ¡Empieza ahora!'),
            );
          }
          return ListView.builder(
            itemCount: metas.length,
            itemBuilder: (context, index) {
              return _buildMetaCard(context, ref, metas[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar metas: $e')),
      ),
    );
  }

  // --- WIDGETS Y LÓGICA ---

  Widget _buildMetaCard(BuildContext context, WidgetRef ref, MetaAhorro meta) {
    final gestor = ref.read(gestorMetaProvider);
    final progreso = meta.montoObjetivo > 0 ? meta.montoAhorrado / meta.montoObjetivo : 0.0;
    final porciento = (progreso * 100).toStringAsFixed(1);
    final diasRestantes = meta.fechaLimite.difference(DateTime.now()).inDays;
    
    final colorCumplida = progreso >= 1.0 ? Colors.green.shade600 : Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.savings, color: colorCumplida),
        title: Text('${meta.nombre} ($porciento%)'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objetivo: \$${meta.montoObjetivo.toStringAsFixed(2)}'),
            Text('Ahorrado: \$${meta.montoAhorrado.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progreso.clamp(0.0, 1.0),
              color: colorCumplida,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              progreso >= 1.0 ? '¡Meta Cumplida!' : 
              diasRestantes > 0 ? 'Faltan $diasRestantes días (Límite: ${DateFormat('dd/MM/yyyy').format(meta.fechaLimite)})' :
              'Fecha límite excedida',
              style: TextStyle(
                color: progreso >= 1.0 ? Colors.green : (diasRestantes < 0 ? Colors.red : Colors.grey),
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => _mostrarDialogoMeta(context, ref, meta), 
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: () => gestor.eliminarMeta(meta.isarId), 
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoMeta(BuildContext context, WidgetRef ref, MetaAhorro? meta) {
    final isEditing = meta != null;
    final gestor = ref.read(gestorMetaProvider);
    final formKey = GlobalKey<FormState>();
    
    String nombre = isEditing ? meta.nombre : '';
    double montoObjetivo = isEditing ? meta.montoObjetivo : 0.0;
    DateTime fechaLimite = isEditing ? meta.fechaLimite : DateTime.now().add(const Duration(days: 30));
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Meta: $nombre' : 'Crear Nueva Meta'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nombre de la meta
                      TextFormField(
                        initialValue: nombre,
                        decoration: const InputDecoration(labelText: 'Nombre de la Meta'),
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese un nombre.' : null,
                        onSaved: (value) => nombre = value!,
                      ),
                      const SizedBox(height: 10),
                      // Monto Objetivo
                      TextFormField(
                        initialValue: montoObjetivo > 0 ? montoObjetivo.toStringAsFixed(2) : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monto Objetivo (\$)', prefixIcon: Icon(Icons.attach_money)),
                        validator: (value) {
                          if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Ingrese un monto válido mayor a 0.';
                          }
                          return null;
                        },
                        onSaved: (value) => montoObjetivo = double.parse(value!),
                      ),
                      const SizedBox(height: 20),
                      // Selector de Fecha Límite
                      ListTile(
                        title: const Text('Fecha Límite'),
                        subtitle: Text(DateFormat('dd/MM/yyyy').format(fechaLimite)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: fechaLimite,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          if (selected != null) setState(() => fechaLimite = selected);
                        },
                      ),
                    ],
                  ),
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
                      gestor.guardarMeta(
                        nombre: nombre,
                        montoObjetivo: montoObjetivo,
                        fechaLimite: fechaLimite,
                        id: isEditing ? meta.isarId : null,
                        montoAhorrado: isEditing ? meta.montoAhorrado : 0.0, 
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(isEditing ? 'Guardar Cambios' : 'Crear Meta'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}