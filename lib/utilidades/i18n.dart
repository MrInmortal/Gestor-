// lib/utilidades/i18n.dart
import 'package:flutter/material.dart';
class T {
  final Locale locale;
  T(this.locale);
  static T of(BuildContext context) {
    // Obtiene la instancia correcta de T para el Locale activo
    return T(Localizations.localeOf(context));
  }
  
  // --- TÍTULOS Y CABECERAS ---
  
  String get tituloApp => {
    'es': 'Gestor de Finanzas',
    'en': 'Finance Manager',
    'pt': 'Gerente Financeiro',
  }[locale.languageCode] ?? 'Gestor de Finanzas';
  
  String get configuracion => {
    'es': 'Configuración',
    'en': 'Settings',
    'pt': 'Configurações',
  }[locale.languageCode] ?? 'Configuración';
  
  String get informesTitle => {
    'es': 'Informes y Análisis',
    'en': 'Reports and Analysis',
    'pt': 'Relatórios e Análise',
  }[locale.languageCode] ?? 'Informes y Análisis';

  // --- NUEVAS CLAVES DE TRANSACCIÓN/PRESUPUESTO ---
  String get nuevaTransaccion => {
    'es': 'Nueva Transacción',
    'en': 'New Transaction',
    'pt': 'Nova Transação',
  }[locale.languageCode] ?? 'Nueva Transacción';

  String get editarTransaccion => {
    'es': 'Editar Transacción',
    'en': 'Edit Transaction',
    'pt': 'Editar Transação',
  }[locale.languageCode] ?? 'Editar Transacción';

  String get gasto => {
    'es': 'Gasto',
    'en': 'Expense',
    'pt': 'Despesa',
  }[locale.languageCode] ?? 'Gasto';
  
  String get ingreso => {
    'es': 'Ingreso',
    'en': 'Income',
    'pt': 'Receita',
  }[locale.languageCode] ?? 'Ingreso';

  String get monto => {
    'es': 'Monto (\$)',
    'en': 'Amount (\$)',
    'pt': 'Valor (\$)',
  }[locale.languageCode] ?? 'Monto (\$);';
  
  // CLAVES NUEVAS (Monto, Categoría)
  String get ingresaMontoValido => {
    'es': 'Ingrese un monto válido mayor a 0.',
    'en': 'Enter a valid amount greater than 0.',
    'pt': 'Insira um valor válido maior que 0.',
  }[locale.languageCode] ?? 'Ingrese un monto válido mayor a 0.';

  String get seleccionaCategoria => {
    'es': 'Seleccione una Categoría',
    'en': 'Select a Category',
    'pt': 'Selecione uma Categoria',
  }[locale.languageCode] ?? 'Seleccione una Categoría';
  
  String get seleccioneCategoria => {
    'es': 'Seleccione una categoría.',
    'en': 'Select a category.',
    'pt': 'Selecione uma categoria.',
  }[locale.languageCode] ?? 'Seleccione una categoría.';
  
  String get descripcion => {
    'es': 'Descripción',
    'en': 'Description',
    'pt': 'Descrição',
  }[locale.languageCode] ?? 'Descripción';
  
  String get fecha => {
    'es': 'Fecha',
    'en': 'Date',
    'pt': 'Data',
  }[locale.languageCode] ?? 'Fecha';

  String get guardarCambios => {
    'es': 'Guardar Cambios',
    'en': 'Save Changes',
    'pt': 'Salvar Alterações',
  }[locale.languageCode] ?? 'Guardar Cambios';

  String get guardarTransaccion => {
    'es': 'Guardar Transacción',
    'en': 'Save Transaction',
    'pt': 'Salvar Transação',
  }[locale.languageCode] ?? 'Guardar Transacción';

  // CLAVES PARA LA ALERTA DE PRESUPUESTO
  String get alertaPresupuesto => {
    'es': '¡Alerta de Presupuesto!',
    'en': 'Budget Alert!',
    'pt': 'Alerta de Orçamento!',
  }[locale.languageCode] ?? '¡Alerta de Presupuesto!';

  String get cancelar => {
    'es': 'Cancelar',
    'en': 'Cancel',
    'pt': 'Cancelar',
  }[locale.languageCode] ?? 'Cancelar';

  String get guardarDeTodosModos => {
    'es': 'Guardar de todos modos',
    'en': 'Save Anyway',
    'pt': 'Salvar de qualquer forma',
  }[locale.languageCode] ?? 'Guardar de todos modos';

  // CLAVES NUEVAS DE METAS
  String get asignarAMeta => {
    'es': 'Asignar a Meta de Ahorro',
    'en': 'Assign to Savings Goal',
    'pt': 'Atribuir à Meta de Poupança',
  }[locale.languageCode] ?? 'Asignar a Meta de Ahorro';
  
  String get ningunaMeta => {
    'es': 'Ninguna Meta de Ahorro',
    'en': 'No Savings Goal',
    'pt': 'Nenhuma Meta de Poupança',
  }[locale.languageCode] ?? 'Ninguna Meta de Ahorro';

  String get sinMetasActivas => {
    'es': 'No hay metas de ahorro activas a las que asignar este ingreso.',
    'en': 'No active savings goals to assign this income to.',
    'pt': 'Não há metas de poupança ativas para atribuir esta receita.',
  }[locale.languageCode] ?? 'No hay metas de ahorro activas a las que asignar este ingreso.';

  // --- DASHBOARD ---
  
  String get saldoActual => {
    'es': 'Saldo Total Actual',
    'en': 'Current Total Balance',
    'pt': 'Saldo Total Atual',
  }[locale.languageCode] ?? 'Saldo Total Actual';
  
  String get ultimasTransacciones => {
    'es': 'Últimas Transacciones',
    'en': 'Latest Transactions',
    'pt': 'Últimas Transações',
  }[locale.languageCode] ?? 'Últimas Transações';
  
  String get tirarParaActualizar => {
    'es': 'Tira para actualizar',
    'en': 'Pull to refresh',
    'pt': 'Puxe para atualizar',
  }[locale.languageCode] ?? 'Tira para actualizar';
  
  // --- CONFIGURACIÓN ---
  
  String get modoOscuro => {
    'es': 'Modo Oscuro',
    'en': 'Dark Mode',
    'pt': 'Modo Escuro',
  }[locale.languageCode] ?? 'Modo Oscuro';
  
  String get modoClaro => {
    'es': 'Modo Claro',
    'en': 'Light Mode',
    'pt': 'Modo Claro',
  }[locale.languageCode] ?? 'Modo Claro';
  
  String get seleccionarIdioma => {
    'es': 'Seleccionar Idioma',
    'en': 'Select Language',
    'pt': 'Selecionar Idioma',
  }[locale.languageCode] ?? 'Seleccionar Idioma';
  
  // --- INFORMES Y FILTROS ---
  
  String get resumenPorCategoria => {
    'es': 'Resumen por Categoría',
    'en': 'Summary by Category',
    'pt': 'Resumo por Categoria',
  }[locale.languageCode] ?? 'Resumen por Categoría';
  
  String get detalleTransacciones => {
    'es': 'Detalle de Transacciones',
    'en': 'Transaction Detail',
    'pt': 'Detalhe das Transações',
  }[locale.languageCode] ?? 'Detalle de Transacciones';
  
  String get errorAlCargarInformes => {
    'es': 'Error al cargar informes',
    'en': 'Error loading reports',
    'pt': 'Erro ao carregar relatórios',
  }[locale.languageCode] ?? 'Error al cargar informes';
  
  // CAMPOS DE FILTRO
  String get filtrarTransacciones => {
    'es': 'Filtrar Transacciones',
    'en': 'Filter Transactions',
    'pt': 'Filtrar Transações',
  }[locale.languageCode] ?? 'Filtrar Transacciones';
  
  String get categoria => {
    'es': 'Categoría',
    'en': 'Category',
    'pt': 'Categoria',
  }[locale.languageCode] ?? 'Categoría';
  
  String get sinFiltro => {
    'es': 'Sin Filtro',
    'en': 'No Filter',
    'pt': 'Sem Filtro',
  }[locale.languageCode] ?? 'Sin Filtro';
  
  String get fechaInicio => {
    'es': 'Fecha de Inicio',
    'en': 'Start Date',
    'pt': 'Data de Início',
  }[locale.languageCode] ?? 'Fecha de Inicio';
  
  String get fechaFin => {
    'es': 'Fecha de Fin',
    'en': 'End Date',
    'pt': 'Data Final',
  }[locale.languageCode] ?? 'Fecha de Fin';
  
  String get seleccionar => {
    'es': 'Seleccionar',
    'en': 'Select',
    'pt': 'Selecionar',
  }[locale.languageCode] ?? 'Seleccionar';
  
  String get limpiarFiltro => {
    'es': 'Limpiar Filtro',
    'en': 'Clear Filter',
    'pt': 'Limpar Filtro',
  }[locale.languageCode] ?? 'Limpiar Filtro';
  
  String get aplicar => {
    'es': 'Aplicar',
    'en': 'Apply',
    'pt': 'Aplicar',
  }[locale.languageCode] ?? 'Aplicar';
  
  String get filtrosActivos => {
    'es': 'Filtros Activos:',
    'en': 'Active Filters:',
    'pt': 'Filtros Ativos:',
  }[locale.languageCode] ?? 'Filtros Activos:';
  
  String get noTransaccionesFiltradas => {
    'es': 'No se encontraron transacciones.',
    'en': 'No transactions found.',
    'pt': 'Nenhuma transação encontrada.',
  }[locale.languageCode] ?? 'No se encontraron transacciones.';
  
  String get inicio => {
    'es': 'Inicio',
    'en': 'Start',
    'pt': 'Início',
  }[locale.languageCode] ?? 'Inicio';
  
  String get fin => {
    'es': 'Fin',
    'en': 'End',
    'pt': 'Fim',
  }[locale.languageCode] ?? 'Fin';
  
  // --- RESUMEN FINANZAS ---
  
  String get ingresosTotales => {
    'es': 'Ingresos Totales',
    'en': 'Total Income',
    'pt': 'Total de Receitas',
  }[locale.languageCode] ?? 'Ingresos Totales';
  
  String get gastosTotales => {
    'es': 'Gastos Totales',
    'en': 'Total Expenses',
    'pt': 'Total de Despesas',
  }[locale.languageCode] ?? 'Gastos Totales';
  
  String get balanceNeto => {
    'es': 'Balance Neto',
    'en': 'Net Balance',
    'pt': 'Saldo Líquido',
  }[locale.languageCode] ?? 'Balance Neto';
}