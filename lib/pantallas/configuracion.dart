// lib/pantallas/configuracion.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:csv/csv.dart';    // Para generar el CSV
import 'package:file_saver/file_saver.dart'; // Para guardar el archivo
import 'dart:typed_data'; // CRÍTICO: Añadir esta importación para Uint8List

import '../gestores/gestor_configuracion.dart';
import '../gestores/servicio_isar.dart'; // Para obtener las transacciones
import '../utilidades/i18n.dart';

class PantallaConfiguracion extends ConsumerWidget {
  const PantallaConfiguracion({super.key});

  // --- LÓGICA DE EXPORTACIÓN CSV ---
  Future<void> _exportarDatos(BuildContext context, WidgetRef ref, T t) async {
    final isarService = ref.read(isarServiceProvider);
    
    try {
      // 1. Obtener todas las transacciones
      final transacciones = await isarService.obtenerTodasLasTransacciones();
      
      if (transacciones.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay transacciones para exportar.')),
        );
        return;
      }

      // 2. Preparar los datos en formato List<List<dynamic>> (CSV)
      List<List<dynamic>> rows = [];
      // Añadir la cabecera
      rows.add(['ID', 'Fecha', 'Tipo', 'Monto', 'Categoría', 'Descripción']);

      // Añadir las filas de datos
      for (var tx in transacciones) {
        rows.add([
          tx.isarId,
          DateFormat('yyyy-MM-dd').format(tx.fecha),
          tx.esGasto ? 'Gasto' : 'Ingreso',
          tx.monto,
          tx.categoria,
          tx.descripcion,
        ]);
      }

      // 3. Convertir la lista a formato CSV (String)
      String csv = const ListToCsvConverter().convert(rows);

      // 4. Guardar el archivo en el dispositivo
      final String fileName = 'finanza_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      
      // Usar file_saver para guardar el archivo
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(csv.codeUnits), // Convierte el String CSV a bytes
        ext: 'csv',
        mimeType: MimeType.csv,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos exportados exitosamente como $fileName')),
      );

    } catch (e) {
      print('Error al exportar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar los datos: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configuracionProvider);
    final gestorConfig = ref.read(configuracionProvider.notifier);
    final t = T.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(t.configuracion)),
      body: ListView(
        children: [
          // 1. CAMBIO DE MODO OSCURO
          SwitchListTile(
            title: Text(config.esModoOscuro ? t.modoOscuro : t.modoClaro),
            secondary: Icon(config.esModoOscuro ? Icons.dark_mode : Icons.light_mode),
            value: config.esModoOscuro,
            onChanged: (value) => gestorConfig.setModoOscuro(value),
          ),
          const Divider(),
          
          // 2. CAMBIO DE IDIOMA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.seleccionarIdioma, style: Theme.of(context).textTheme.titleMedium),
                DropdownButton<String>(
                  value: config.idiomaCodigo,
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'pt', child: Text('Português')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      gestorConfig.setIdioma(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          
          // 3. EXPORTACIÓN DE DATOS CSV
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Exportar Datos (CSV)'),
            subtitle: const Text('Guarda todas las transacciones en un archivo CSV.'),
            onTap: () => _exportarDatos(context, ref, t),
          ),
        ],
      ),
    );
  }
}