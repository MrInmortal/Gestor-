// lib/utilidades/ayudantes.dart
import 'package:flutter/material.dart';

// Mapeo de categorías a iconos descriptivos (más allá del simple restaurant)
IconData obtenerIconoPorCategoria(String categoria) {
  switch (categoria.toLowerCase()) {
    case 'comida':
      return Icons.fastfood_rounded;
    case 'transporte':
      return Icons.tram_rounded;
    case 'salud':
      return Icons.medication_liquid_rounded;
    case 'hogar':
      return Icons.lightbulb_outline_rounded;
    case 'ocio':
      return Icons.movie_creation_rounded;
    case 'ingreso':
      return Icons.attach_money_rounded;
    case 'otros':
      return Icons.label_important_outline_rounded;
    default:
      return Icons.category_rounded;
  }
}

// Función para obtener el color de un gasto/ingreso basado en el tema
Color obtenerColorPorTipo(BuildContext context, bool esGasto) {
  final colorScheme = Theme.of(context).colorScheme;
  if (esGasto) {
    // Usamos el color de error para gastos (rojo)
    return colorScheme.error; 
  } else {
    // Usamos el color primario para ingresos (morado/azul)
    return colorScheme.primary;
  }
}