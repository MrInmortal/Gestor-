// lib/utilidades/temas.dart
import 'package:flutter/material.dart';

class AppThemes {
  static final Color primaryColor = Colors.deepPurple;
  static final Color secondaryColor = Colors.purpleAccent;
  
  // Colores simples para el fondo de las tarjetas
  static const Color darkCardColor = Color(0xFF2C3E50); 
  static const Color lightCardColor = Colors.white;

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: lightCardColor, // Usamos cardColor simple (tipo Color)
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple.shade300, 
      secondary: Colors.purpleAccent.shade400, 
      surface: const Color(0xFF1A1A2E), 
      onSurface: Colors.white70,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: darkCardColor, // Usamos cardColor simple (tipo Color)
    useMaterial3: true,
  );
}