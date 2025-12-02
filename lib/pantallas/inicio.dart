// lib/pantallas/inicio.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../gestores/gestor_transaccion.dart';
import '../gestores/servicio_isar.dart';
import '../modelos/transaccion.dart'; 
import '../utilidades/i18n.dart';
import '../utilidades/ayudantes.dart'; 
import 'informes.dart';
import 'nueva_transaccion.dart';
import 'configuracion.dart'; 
import 'presupuestos.dart';
import 'metas.dart'; 

// --- PROVIDERS DEL DASHBOARD ---

// 1. Provider para el cálculo del Saldo Total usando Stream (Ya es reactivo)
final saldoTotalStreamProvider = StreamProvider<double>((ref) async* {
  final isarService = ref.watch(isarServiceProvider);
  yield* isarService.escucharSaldoTotal(); 
});

// 2. Provider para Ingresos y Gastos Netos del mes actual (ACTUALIZADO para reactividad)
final resumenMensualProvider = FutureProvider<Map<String, double>>((ref) async {
    // CRÍTICO: Observar el stream de transacciones para re-ejecutar en cada cambio
    final transaccionesAsync = ref.watch(transaccionesStreamProvider);

    final allTxs = await transaccionesAsync.when(
        data: (txs) => txs,
        loading: () => [],
        error: (e, s) => throw e,
    );

    final now = DateTime.now();
    // Establecer el inicio del mes
    final startOfMonth = DateTime(now.year, now.month, 1);
    // Establecer el final del mes
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(seconds: 1));
    
    double ingresos = 0;
    double gastos = 0;
    
    for (var tx in allTxs) {
        // Excluir ingresos destinados a metas del resumen mensual
        if (!tx.esGasto && tx.metaId != null) {
            continue; 
        }

        // Usar la fecha de la transacción (tx.fecha) para el resumen mensual
        if (tx.fecha.isAfter(startOfMonth.subtract(const Duration(days: 1))) && 
            tx.fecha.isBefore(endOfMonth.add(const Duration(days: 1)))) {
            if (tx.esGasto) {
                gastos += tx.monto;
            } else {
                ingresos += tx.monto;
            }
        }
    }
    return {'ingresos': ingresos, 'gastos': gastos, 'neto': ingresos - gastos};
});

class PantallaDashboard extends ConsumerWidget {
  const PantallaDashboard({super.key});

  // Función para recargar todos los datos (Ahora solo invalida si es necesario)
  Future<void> _refreshData(WidgetRef ref) async {
      // El resumenMensualProvider ahora es reactivo por defecto, 
      // pero invalidarlo asegura que se re-ejecute al hacer "Pull to refresh"
      ref.invalidate(resumenMensualProvider); 
      ref.invalidate(transaccionesStreamProvider); 
      await ref.read(resumenMensualProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = T.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tituloApp),
        actions: [
          // NUEVO: Botón de METAS DE AHORRO
          IconButton(
            icon: const Icon(Icons.savings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PantallaMetas())),
          ),
          // Botón de PRESUPUESTOS 
          IconButton(
            icon: const Icon(Icons.wallet_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PantallaPresupuestos())),
          ),
          // Botón de AJUSTES
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PantallaConfiguracion())),
          ),
          // Botón de INFORMES
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PantallaInformes())),
          ),
        ],
      ),
      // IMPLEMENTACIÓN DE REFRESH INDICATOR
      body: RefreshIndicator(
        onRefresh: () => _refreshData(ref),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TARJETA DE SALDO TOTAL
              _buildSaldoTotalCard(ref, context, t),
              
              const SizedBox(height: 30),
              
              // 2. WIDGETS DE RESUMEN RÁPIDO (Ingresos/Gastos Netos)
              _buildQuickSummaryWidgets(context, ref, t), 
              
              const SizedBox(height: 30),
              // 3. LISTA DE ÚLTIMAS TRANSACCIONES (Ahora con Editar/Eliminar)
              Text(t.ultimasTransacciones, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              _buildListaTransacciones(ref, context), 
              
              const SizedBox(height: 50),
              
              // Espacio reservado para ver el Pull-to-Refresh
              Center(child: Text(t.tirarParaActualizar ?? 'Tira para actualizar', style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)))),
            ],
          ),
        ),
      ),
      // Botón flotante para AÑADIR (Icons.add)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // El .then((_) => _refreshData(ref)) ahora solo invalida los FutureProviders
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PantallaNuevaTransaccion()),
          ).then((_) => _refreshData(ref)); 
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- WIDGET PARA LA TARJETA DE SALDO TOTAL ---
  Widget _buildSaldoTotalCard(WidgetRef ref, BuildContext context, T t) {
    // Usamos el StreamProvider reactivo
    final totalAsync = ref.watch(saldoTotalStreamProvider); 
    
    return Card(
      color: Theme.of(context).cardColor, 
      elevation: 8, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        // Manejamos el AsyncValue (StreamProvider)
        child: totalAsync.when(
          data: (saldo) {
            final isPositive = saldo >= 0;
            final totalColor = isPositive 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.error;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.saldoActual, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.7),
                )),
                const SizedBox(height: 12),
                
                // Saldo grande y destacado con icono
                Row(
                  children: [
                    Icon(isPositive ? Icons.account_balance_wallet_rounded : Icons.money_off_rounded, color: totalColor, size: 30),
                    const SizedBox(width: 10),
                    Text('\$${saldo.toStringAsFixed(2)}', 
                         style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                           color: totalColor,
                           fontWeight: FontWeight.bold,
                         )),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: Text('Calculando saldo...')),
          error: (e, s) => Text('Error al cargar saldo: $e'),
        ),
      ),
    );
  }
  
  // --- WIDGET DE RESUMEN RÁPIDO (Ingresos/Gastos) ---
  Widget _buildQuickSummaryWidgets(BuildContext context, WidgetRef ref, T t) {
      final resumenAsync = ref.watch(resumenMensualProvider);
      return resumenAsync.when(
          data: (resumen) {
              final netColor = resumen['neto']! >= 0 ? Colors.green.shade600 : Colors.red.shade600;
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      // Tarjeta de Ingresos
                      _buildSummaryCard(context, Icons.arrow_downward, t.ingresosTotales, resumen['ingresos']!, Colors.green.shade700),
                      const SizedBox(width: 8),
                      // Tarjeta de Gastos
                      _buildSummaryCard(context, Icons.arrow_upward, t.gastosTotales, resumen['gastos']!, Colors.red.shade700),
                      const SizedBox(width: 8),
                      // Tarjeta Neta
                      _buildSummaryCard(context, Icons.paid_rounded, t.balanceNeto, resumen['neto']!, netColor),
                  ],
              );
          },
          loading: () => const Center(child: LinearProgressIndicator()),
          error: (e, s) => const Text('Error cargando resumen.'),
      );
  }
  
  // Helper para construir las tarjetas de resumen
  Widget _buildSummaryCard(BuildContext context, IconData icon, String title, double amount, Color color) {
      return Expanded(
          child: Card(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                      children: [
                          Icon(icon, color: color, size: 24),
                          const SizedBox(height: 4),
                          Text(title, style: TextStyle(color: color, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('\$${amount.toStringAsFixed(2)}', 
                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).textTheme.bodyLarge!.color)),
                      ],
                  ),
              ),
          ),
      );
  }

  // --- WIDGET PARA LISTAR TRANSACCIONES (Con Botones de Editar/Eliminar) ---
  Widget _buildListaTransacciones(WidgetRef ref, BuildContext context) {
    final transaccionesAsync = ref.watch(transaccionesStreamProvider);
    final gestor = ref.read(gestorTransaccionProvider); 
    
    return transaccionesAsync.when(
      data: (transacciones) {
        if (transacciones.isEmpty) return const SizedBox.shrink();
        
        final ultimas = transacciones.take(5).toList(); 
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: ultimas.length,
          itemBuilder: (context, index) {
            final tx = ultimas[index];
            final isExpense = tx.esGasto;
            final color = isExpense 
                ? Theme.of(context).colorScheme.error 
                : Theme.of(context).colorScheme.primary;
            
            return Dismissible( 
              key: ValueKey(tx.isarId),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red.shade700,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete_forever, color: Colors.white),
              ),
              onDismissed: (direction) {
                gestor.eliminarTransaccion(tx.isarId); 
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transacción eliminada: ${tx.descripcion}')),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(
                      obtenerIconoPorCategoria(tx.categoria), 
                      color: color),
                ),
                title: Text(tx.descripcion),
                subtitle: Text('${tx.categoria} - ${DateFormat('dd/MM/yyyy').format(tx.fecha)}'),
                
                // BOTONES DE EDICIÓN Y VALOR (Trailing)
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}\$${tx.monto.toStringAsFixed(2)}',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                    // BOTÓN DE EDICIÓN
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PantallaNuevaTransaccion(transactionToEdit: tx), 
                          ),
                        ).then((_) => _refreshData(ref)); 
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Error al cargar lista.')),
    );
  }
}