// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

// CRÍTICO: Importar el archivo donde está la clase PantallaDashboard.
// Asumo que la clase PantallaDashboard está definida en inicio.dart.
import 'pantallas/inicio.dart'; 

import 'utilidades/temas.dart';
import 'gestores/gestor_configuracion.dart';

void main() async {
  // Inicializa Widgets antes de llamar a SharedPreferences
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuracion = ref.watch(configuracionProvider);
    
    return MaterialApp(
      title: 'BudgetFlow',
      
      // Elimina la etiqueta "DEBUG"
      debugShowCheckedModeBanner: false, 
      
      // Configuración de temas
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: configuracion.esModoOscuro ? ThemeMode.dark : ThemeMode.light,
      
      // Configuración de idiomas (i18n)
      localizationsDelegates: [ 
        GlobalMaterialLocalizations.delegate, 
        GlobalWidgetsLocalizations.delegate,  
        GlobalCupertinoLocalizations.delegate, 
      ],
      supportedLocales: const [
        Locale('es', ''), 
        Locale('en', ''), 
        Locale('pt', ''), 
      ],
      locale: Locale(configuracion.idiomaCodigo), 
      
      // La pantalla principal es el Dashboard
      home: const PantallaDashboard(), 
    );
  }
}