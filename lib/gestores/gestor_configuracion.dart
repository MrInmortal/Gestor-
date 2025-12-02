// lib/gestores/gestor_configuracion.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// RUTA CORREGIDA: debe ser relativa, no de paquete.
import '../modelos/configuracion.dart'; 

final _defaultConfig = ConfiguracionModel(
  esModoOscuro: false,
  idiomaCodigo: 'es',
);

class GestorConfiguracion extends StateNotifier<ConfiguracionModel> {
  GestorConfiguracion() : super(_defaultConfig) {
    _cargarConfiguracion();
  }
  
  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    state = ConfiguracionModel( 
      esModoOscuro: prefs.getBool('esModoOscuro') ?? _defaultConfig.esModoOscuro,
      idiomaCodigo: prefs.getString('idiomaCodigo') ?? _defaultConfig.idiomaCodigo,
    );
  }

  Future<void> _guardarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('esModoOscuro', state.esModoOscuro);
    prefs.setString('idiomaCodigo', state.idiomaCodigo);
  }

  void setModoOscuro(bool valor) {
    state = state.copyWith(esModoOscuro: valor);
    _guardarConfiguracion();
  }

  void setIdioma(String codigo) {
    state = state.copyWith(idiomaCodigo: codigo);
    _guardarConfiguracion();
  }
}

final configuracionProvider = StateNotifierProvider<GestorConfiguracion, ConfiguracionModel>(
  (ref) => GestorConfiguracion(),
);