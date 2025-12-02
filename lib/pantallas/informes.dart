// lib/pantallas/informes.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../gestores/servicio_isar.dart';
import '../modelos/transaccion.dart';
import '../utilidades/i18n.dart';
import '../modelos/filtro.dart'; 
import '../gestores/gestor_transaccion.dart'; 

// --- PROVIDERS ---

// 1. Provider para manejar el estado de los filtros
final filtroEstadoProvider = StateProvider<FiltroEstado>((ref) {
  return FiltroEstado();
});

// 2. Provider para obtener Transacciones FILTRADAS (CORREGIDO el error de tipo con .cast)
final transaccionesFiltradasProvider = FutureProvider<List<Transaccion>>((ref) async {
  
  final transaccionesStream = ref.watch(transaccionesStreamProvider); 

  final todasTxs = await transaccionesStream.when(
    data: (txs) => txs,
    loading: () => [], 
    error: (e, s) => throw e,
  );
  
  final filtro = ref.watch(filtroEstadoProvider);
  
  // Lógica de filtrado
  return todasTxs.where((tx) {
    bool pasaFecha = true;
    bool pasaCategoria = true;
    
    // Filtro por Fecha de Inicio
    if (filtro.fechaInicio != null) {
      final inicioAjustado = DateTime(filtro.fechaInicio!.year, filtro.fechaInicio!.month, filtro.fechaInicio!.day);
      if (tx.fecha.isBefore(inicioAjustado)) {
        pasaFecha = false;
      }
    }
    // Filtro por Fecha de Fin
    if (filtro.fechaFin != null) {
      final fechaFinAjustada = DateTime(filtro.fechaFin!.year, filtro.fechaFin!.month, filtro.fechaFin!.day, 23, 59, 59);
      if (tx.fecha.isAfter(fechaFinAjustada)) {
        pasaFecha = false;
      }
    }
    // Filtro por Categoría
    if (filtro.categoria != null && filtro.categoria!.isNotEmpty) {
      if (tx.categoria.toLowerCase() != filtro.categoria!.toLowerCase()) {
        pasaCategoria = false;
      }
    }
    return pasaFecha && pasaCategoria;
  }).toList()
  .cast<Transaccion>(); // CORRECCIÓN CLAVE para el error de List<dynamic>
});

// 3. Provider para el cálculo de saldo histórico (ACTUALIZADO con .cast)
final saldoHistoricoProvider = FutureProvider<Map<DateTime, double>>((ref) async {
  
  final transaccionesStream = ref.watch(transaccionesStreamProvider); 

  final allTxs = await transaccionesStream.when(
    data: (txs) => txs,
    loading: () => [], 
    error: (e, s) => throw e,
  );
  
  // Calcular el saldo acumulado mes a mes
  final now = DateTime.now();
  final data = <DateTime, double>{};
  
  for (int i = 5; i >= 0; i--) {
    final mes = DateTime(now.year, now.month - i, 1);
    final finMes = DateTime(now.year, now.month - i + 1, 1).subtract(const Duration(seconds: 1));

    final txsHastaFinMes = allTxs.where((tx) => tx.fecha.isBefore(finMes)).toList().cast<Transaccion>(); // Aplicar .cast aquí por seguridad

    double saldo = 0;
    for (var tx in txsHastaFinMes) {
      if (tx.esGasto) {
        saldo -= tx.monto;
      } else {
        saldo += tx.monto;
      }
    }
    data[mes] = saldo;
  }
  return data;
});

class PantallaInformes extends ConsumerWidget {
  const PantallaInformes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = T.of(context);
    final filtro = ref.watch(filtroEstadoProvider);
    final txsAsync = ref.watch(transaccionesFiltradasProvider);
    
    // Usamos DefaultTabController para crear las pestañas
    return DefaultTabController(
      length: 2, // Dos pestañas: Circular (Categoría) y Línea (Histórico)
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.informesTitle),
          actions: [
            // Botón para ABRIR FILTROS
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () => _mostrarDialogoFiltros(context, ref, t),
            ),
          ],
          // TabBar para las dos vistas de informes
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pie_chart_outline), text: 'Categoría'),
              Tab(icon: Icon(Icons.show_chart), text: 'Histórico'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña 1: Gráfico Circular (Resumen por Categoría y Detalle)
            _buildResumenPorCategoria(txsAsync, filtro, context, ref, t),
            
            // Pestaña 2: Gráfico de Líneas (Saldo Histórico)
            _buildSaldoHistorico(ref, context),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PESTAÑA 1: RESUMEN POR CATEGORÍA (Gráfico Circular) ---
  Widget _buildResumenPorCategoria(
      AsyncValue<List<Transaccion>> txsAsync, 
      FiltroEstado filtro, 
      BuildContext context, 
      WidgetRef ref, 
      T t) {
    
    return txsAsync.when(
      data: (transacciones) {
        if (transacciones.isEmpty) {
          return Center(child: Text(t.noTransaccionesFiltradas));
        }
        
        final dataChart = _obtenerDatosPieChart(transacciones, context);
        final hayGastos = dataChart.isNotEmpty; 
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFiltroActivo(filtro, context, ref, t),
              const SizedBox(height: 16),
              
              Text(t.resumenPorCategoria, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              
              // WIDGET DE GRÁFICO CIRCULAR
              SizedBox(
                height: 300,
                child: hayGastos
                    ? PieChart(
                        PieChartData(
                          sections: dataChart,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      )
                    : Center(
                        child: Text(
                          'No hay gastos en el rango de filtro para mostrar el gráfico.',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(height: 30),
              
              Text(t.detalleTransacciones, style: Theme.of(context).textTheme.headlineSmall),
              // LISTADO DETALLADO DE TRANSACCIONES FILTRADAS
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transacciones.length,
                itemBuilder: (context, index) {
                  final tx = transacciones[index];
                  return ListTile(
                    title: Text(tx.descripcion),
                    subtitle: Text('${tx.categoria} - ${DateFormat('dd/MM/yyyy').format(tx.fecha)}'),
                    trailing: Text(
                      '${tx.esGasto ? '-' : '+'}\$${tx.monto.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: tx.esGasto ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('${t.errorAlCargarInformes}: $e')),
    );
  }

  // --- WIDGET PESTAÑA 2: SALDO HISTÓRICO (Gráfico de Líneas) ---
  Widget _buildSaldoHistorico(WidgetRef ref, BuildContext context) {
    final saldoHistoricoAsync = ref.watch(saldoHistoricoProvider);

    return saldoHistoricoAsync.when(
      data: (datos) {
        if (datos.length < 2) {
          return const Center(child: Text('Necesitas al menos datos de dos meses para mostrar el historial.'));
        }
        
        // Convertir datos (Map<DateTime, double>) a una lista de puntos para el gráfico.
        final puntos = datos.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)); // Orden cronológico

        // Encontrar el valor máximo y mínimo para el eje Y
        double maxSaldo = puntos.map((e) => e.value).reduce((a, b) => a > b ? a : b);
        double minSaldo = puntos.map((e) => e.value).reduce((a, b) => a < b ? a : b);
        
        // Ajustar el rango del eje Y para que no esté pegado al borde
        double padding = (maxSaldo - minSaldo).abs() * 0.1;
        if (padding == 0) padding = 100; 
        
        double maxY = maxSaldo + padding;
        double minY = minSaldo - padding;
        if (minY > 0 && minSaldo > 0) minY = 0; 

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Evolución del Saldo (Últimos ${puntos.length} meses)', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: puntos.length.toDouble() - 1, 
                      minY: minY,
                      maxY: maxY,
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Muestra la abreviatura del mes
                              if (value.toInt() >= 0 && value.toInt() < puntos.length) {
                                final mes = puntos[value.toInt()].key;
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  child: Text(DateFormat('MMM', 'es').format(mes), style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            interval: 1, // Mostrar todos los meses
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Formatea el eje Y con un prefijo $
                              return Text('\$${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10));
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: puntos.asMap().entries.map((entry) {
                            // X es el índice (posición en el gráfico), Y es el saldo
                            return FlSpot(entry.key.toDouble(), entry.value.value);
                          }).toList(),
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error al cargar historial: $e')),
    );
  }


  // --- HELPERS Y WIDGETS ---
  // Lógica para el PieChart (Sin cambios)
  List<PieChartSectionData> _obtenerDatosPieChart(List<Transaccion> txs, BuildContext context) {
    final Map<String, double> gastosPorCategoria = {};
    
    for (var tx in txs.where((t) => t.esGasto)) {
      gastosPorCategoria.update(tx.categoria, (value) => value + tx.monto, ifAbsent: () => tx.monto);
    }
    
    final totalGastos = gastosPorCategoria.values.fold(0.0, (sum, item) => sum + item);
    
    if (totalGastos == 0) return [];
    
    final Map<String, Color> colorMap = {
      'Comida': Colors.orange.shade700, 'Transporte': Colors.blue.shade700, 'Salud': Colors.red.shade700,
      'Hogar': Colors.green.shade700, 'Ocio': Colors.purple.shade700, 'Otros': Colors.grey.shade700,
    };
    
    return gastosPorCategoria.entries.map((entry) {
      final categoria = entry.key; 
      final monto = entry.value; 
      final porcentaje = (monto / totalGastos) * 100;
      final color = colorMap[categoria] ?? Colors.grey;
      
      return PieChartSectionData(
        color: color,
        value: monto,
        title: '${porcentaje.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
  
  // --- CÓDIGO DEL DIÁLOGO DE FILTROS (MANTENIDO IGUAL) ---
  
  void _mostrarDialogoFiltros(BuildContext context, WidgetRef ref, T t) {
    final currentFiltro = ref.read(filtroEstadoProvider);
    DateTime? fechaInicio = currentFiltro.fechaInicio;
    DateTime? fechaFin = currentFiltro.fechaFin;
    String? categoria = currentFiltro.categoria;
    
    final List<String> categoriasDisponibles = ['Comida', 'Transporte', 'Salud', 'Hogar', 'Ocio', 'Ingreso', 'Otros'];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(t.filtrarTransacciones),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filtro de Categoría
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: t.categoria),
                      value: categoria,
                      items: [
                        DropdownMenuItem(value: '', child: Text(t.sinFiltro)),
                        ...categoriasDisponibles.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        )),
                      ],
                      onChanged: (value) => setState(() => categoria = value),
                    ),
                    const SizedBox(height: 20),
                    
                    // Filtro Fecha Inicio
                    ListTile(
                      title: Text(t.fechaInicio),
                      subtitle: Text(fechaInicio == null ? t.seleccionar : DateFormat('dd/MM/yyyy').format(fechaInicio!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (selected != null) setState(() => fechaInicio = selected);
                      },
                    ),
                    
                    // Filtro Fecha Fin
                    ListTile(
                      title: Text(t.fechaFin),
                      subtitle: Text(fechaFin == null ? t.seleccionar : DateFormat('dd/MM/yyyy').format(fechaFin!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: fechaFin ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (selected != null) setState(() => fechaFin = selected);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(filtroEstadoProvider.notifier).state = FiltroEstado();
                    Navigator.of(context).pop();
                  },
                  child: Text(t.limpiarFiltro),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Aplicar el filtro
                    ref.read(filtroEstadoProvider.notifier).state = FiltroEstado(
                      fechaInicio: fechaInicio,
                      fechaFin: fechaFin,
                      categoria: categoria,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(t.aplicar),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildFiltroActivo(FiltroEstado filtro, BuildContext context, WidgetRef ref, T t) {
    final filtrosAplicados = <Widget>[];
    if (filtro.fechaInicio != null) {
      filtrosAplicados.add(Chip(
        label: Text('${t.inicio}: ${DateFormat('dd/MM').format(filtro.fechaInicio!)}'),
        onDeleted: () => _limpiarFiltro(ref, 'fechaInicio'),
      ));
    }
    if (filtro.fechaFin != null) {
      filtrosAplicados.add(Chip(
        label: Text('${t.fin}: ${DateFormat('dd/MM').format(filtro.fechaFin!)}'),
        onDeleted: () => _limpiarFiltro(ref, 'fechaFin'),
      ));
    }
    if (filtro.categoria != null && filtro.categoria!.isNotEmpty) {
      filtrosAplicados.add(Chip(
        label: Text('${t.categoria}: ${filtro.categoria}'),
        onDeleted: () => _limpiarFiltro(ref, 'categoria'),
      ));
    }
    if (filtrosAplicados.isEmpty) {
      return Container();
    }
    return Wrap(
      spacing: 8.0,
      children: [
        Text(t.filtrosActivos, style: Theme.of(context).textTheme.titleSmall),
        ...filtrosAplicados,
      ],
    );
  }
  
  void _limpiarFiltro(WidgetRef ref, String tipo) {
    final current = ref.read(filtroEstadoProvider);
    FiltroEstado newState;
    if (tipo == 'fechaInicio') {
      newState = current.copyWith(fechaInicio: null);
    } else if (tipo == 'fechaFin') {
      newState = current.copyWith(fechaFin: null);
    } else if (tipo == 'categoria') {
      newState = current.copyWith(categoria: '');
    } else {
      newState = current;
    }
    ref.read(filtroEstadoProvider.notifier).state = newState;
  }
}