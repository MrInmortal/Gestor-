// lib/pantallas/nueva_transaccion.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart'; // Necesario para el tipo 'Id' de metaId

import '../gestores/gestor_transaccion.dart';
import '../gestores/gestor_presupuesto.dart';
import '../gestores/gestor_meta.dart'; // Importar gestor de metas
import '../modelos/transaccion.dart';
import '../modelos/meta_ahorro.dart'; // Importar modelo de meta
import '../utilidades/ayudantes.dart'; 
import '../utilidades/i18n.dart';

// --- FUNCIONES AUXILIARES GLOBALES (SOLUCIÓN A ERROR G76A9B1F6) ---
const List<String> _categoriasGasto = ['Comida', 'Transporte', 'Salud', 'Hogar', 'Ocio', 'Otros'];
const List<String> _categoriasIngreso = ['Ingreso'];

List<String> obtenerCategorias(bool esGasto) {
  return esGasto ? _categoriasGasto : _categoriasIngreso;
}
// -----------------------------------------------------------------------


// Este widget es la pantalla de Nueva Transacción, ahora recibe un objeto para edición
class PantallaNuevaTransaccion extends ConsumerStatefulWidget {
  final Transaccion? transactionToEdit;

  const PantallaNuevaTransaccion({super.key, this.transactionToEdit});

  @override
  ConsumerState<PantallaNuevaTransaccion> createState() => _PantallaNuevaTransaccionState();
}

class _PantallaNuevaTransaccionState extends ConsumerState<PantallaNuevaTransaccion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  
  // Datos del formulario
  late bool _esGasto;
  late String _categoria;
  late DateTime _fecha;
  
  // Campo para el ID de la meta seleccionada
  int? _selectedMetaId; // Usamos int? para coincidir con el campo en Transaccion
  
  @override
  void initState() {
    super.initState();
    final tx = widget.transactionToEdit;

    if (tx != null) {
      // Modo Edición
      _esGasto = tx.esGasto;
      _categoria = tx.categoria;
      _fecha = tx.fecha;
      _montoController.text = tx.monto.toStringAsFixed(2);
      _descripcionController.text = tx.descripcion;
      _selectedMetaId = tx.metaId; // Cargar metaId si existe
    } else {
      // Modo Creación
      _esGasto = true;
      _categoria = obtenerCategorias(_esGasto).first;
      _fecha = DateTime.now();
      _montoController.text = '';
      _descripcionController.text = '';
      _selectedMetaId = null; 
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE GUARDADO Y VALIDACIÓN ---

  // Función para mostrar la alerta de presupuesto excedido (Sin cambios)
  Future<bool> _mostrarAlertaPresupuesto(BuildContext context, T t, String categoria, double gastoActual, double montoPresupuestado, double nuevoGasto) async {
    final excedente = (gastoActual + nuevoGasto) - montoPresupuestado;
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.alertaPresupuesto),
        content: Text(
          'El presupuesto de **$categoria** es de \$${montoPresupuestado.toStringAsFixed(2)}.\n\n'
          'Este nuevo gasto de **\$${nuevoGasto.toStringAsFixed(2)}** excedería el presupuesto en **\$${excedente.toStringAsFixed(2)}**.\n\n'
          '¿Desea guardar la transacción de todos modos?',
        ),
        actions: [
          TextButton(
            child: Text(t.cancelar, style: const TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(false), 
          ),
          ElevatedButton(
            child: Text(t.guardarDeTodosModos),
            onPressed: () => Navigator.of(ctx).pop(true), 
          ),
        ],
      ),
    ) ?? false;
  }


  // Lógica de guardado y validación
  void _guardarTransaccion(T t) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final monto = double.parse(_montoController.text);
      final descripcion = _descripcionController.text;
      
      final gestorTransaccion = ref.read(gestorTransaccionProvider);
      final gestorPresupuesto = ref.read(gestorPresupuestoProvider); 

      // 1. Validación de Presupuesto (Mantenida igual)
      if (_esGasto && widget.transactionToEdit == null && _fecha.month == DateTime.now().month && _fecha.year == DateTime.now().year) {
          final presupuesto = await gestorPresupuesto.obtenerPresupuesto(_categoria);
          final montoPresupuestado = presupuesto?.montoPresupuestado ?? 0.0;

          if (montoPresupuestado > 0) {
              final gastoActual = await gestorPresupuesto.obtenerGastoRealActual(_categoria);
              final nuevoGasto = monto;

              if (gastoActual + nuevoGasto > montoPresupuestado) {
                  final continuar = await _mostrarAlertaPresupuesto(
                      context, t, _categoria, 
                      gastoActual, 
                      montoPresupuestado, 
                      nuevoGasto
                  );
                  if (!continuar) return; 
              }
          }
      }

      // 2. Lógica de Creación/Actualización (Usando el constructor original)
      final Transaccion transaccion;
      
      if (widget.transactionToEdit != null) {
        // Edición/Actualización
        transaccion = Transaccion(
          isarId: widget.transactionToEdit!.isarId, 
          categoria: _categoria,
          monto: monto,
          fecha: _fecha, 
          descripcion: descripcion,
          esGasto: _esGasto,
          metaId: _selectedMetaId, // Pasar el ID de la meta
        );
      } else {
        // Creación (Nueva Transacción)
        transaccion = Transaccion(
            categoria: _categoria,
            monto: monto,
            fecha: _fecha, 
            descripcion: descripcion,
            esGasto: _esGasto,
            metaId: _selectedMetaId, // Pasar el ID de la meta
        );
      }
      
      await gestorTransaccion.guardarTransaccion(transaccion);
      
      if (mounted) Navigator.of(context).pop();

      final snackBar = SnackBar(
        content: Text(widget.transactionToEdit != null ? t.editarTransaccion : t.nuevaTransaccion),
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
  // Selector de Fecha (Sin cambios)
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = T.of(context);
    final isEditing = widget.transactionToEdit != null;
    final title = isEditing ? t.editarTransaccion : t.nuevaTransaccion;
    
    // Escuchar el stream de metas para el selector
    final metasAsync = ref.watch(metasStreamProvider); 

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TIPO DE TRANSACCIÓN (Gasto / Ingreso)
              ToggleButtons(
                borderRadius: BorderRadius.circular(8.0),
                isSelected: [_esGasto, !_esGasto],
                onPressed: isEditing ? null : (int index) {
                  setState(() {
                    _esGasto = index == 0;
                    // Resetear categoría y meta al cambiar de tipo
                    _categoria = obtenerCategorias(_esGasto).first;
                    _selectedMetaId = null; 
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(t.gasto, style: TextStyle(color: _esGasto ? Colors.white : Colors.red)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(t.ingreso, style: TextStyle(color: !_esGasto ? Colors.white : Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 2. MONTO
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t.monto,
                  prefixIcon: const Icon(Icons.attach_money),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value!) <= 0) {
                    return t.ingresaMontoValido; // Clave de traducción corregida
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // 3. CATEGORÍA
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: InputDecoration(
                  labelText: t.categoria,
                  prefixIcon: const Icon(Icons.category),
                  border: const OutlineInputBorder(),
                ),
                items: obtenerCategorias(_esGasto).map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _categoria = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // 4. DESCRIPCIÓN
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: t.descripcion,
                  prefixIcon: const Icon(Icons.text_fields),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? t.descripcion : null, // Usar descripción como mensaje de error temporal
              ),
              const SizedBox(height: 20),

              // 5. FECHA
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('${t.fecha}: ${DateFormat('dd/MM/yyyy').format(_fecha)}'),
                trailing: const Icon(Icons.edit),
                onTap: () => _seleccionarFecha(context),
              ),
              const SizedBox(height: 20),

              // 6. NUEVO: SELECTOR DE META DE AHORRO (Solo para Ingresos)
              if (!_esGasto)
                metasAsync.when(
                  data: (metas) {
                    final metasActivas = metas.where((m) => m.montoAhorrado < m.montoObjetivo).toList();
                    
                    if (metasActivas.isEmpty && _selectedMetaId == null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(t.sinMetasActivas, 
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      );
                    }
                    
                    final items = metasActivas.map<DropdownMenuItem<int>>((meta) {
                        final restante = meta.montoObjetivo - meta.montoAhorrado;
                        return DropdownMenuItem<int>(
                            value: meta.isarId,
                            child: Text('${meta.nombre} (Faltan: \$${restante.toStringAsFixed(2)})'),
                        );
                    }).toList();
                    
                    // Opción para "Ninguna"
                    items.insert(0, DropdownMenuItem<int>(
                        value: null,
                        child: Text(t.ningunaMeta),
                    ));

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                            labelText: t.asignarAMeta, // Clave de traducción corregida
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.savings_outlined),
                        ),
                        value: _selectedMetaId,
                        items: items,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedMetaId = newValue;
                          });
                        },
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, s) => Text('Error cargando metas: $e'),
                ),

              // 7. BOTÓN DE GUARDAR
              ElevatedButton(
                onPressed: () => _guardarTransaccion(t),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(isEditing ? t.guardarCambios : t.guardarTransaccion),
              ),
              const SizedBox(height: 10),
              
              // 8. BOTÓN DE CANCELAR
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.cancelar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}