// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presupuesto.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPresupuestoCollection on Isar {
  IsarCollection<Presupuesto> get presupuestos => this.collection();
}

const PresupuestoSchema = CollectionSchema(
  name: r'Presupuesto',
  id: -7889582101979357000,
  properties: {
    r'categoria': PropertySchema(
      id: 0,
      name: r'categoria',
      type: IsarType.string,
    ),
    r'fechaCreacion': PropertySchema(
      id: 1,
      name: r'fechaCreacion',
      type: IsarType.dateTime,
    ),
    r'montoPresupuestado': PropertySchema(
      id: 2,
      name: r'montoPresupuestado',
      type: IsarType.double,
    )
  },
  estimateSize: _presupuestoEstimateSize,
  serialize: _presupuestoSerialize,
  deserialize: _presupuestoDeserialize,
  deserializeProp: _presupuestoDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'categoria': IndexSchema(
      id: -697249392299839610,
      name: r'categoria',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoria',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _presupuestoGetId,
  getLinks: _presupuestoGetLinks,
  attach: _presupuestoAttach,
  version: '3.1.0+1',
);

int _presupuestoEstimateSize(
  Presupuesto object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoria.length * 3;
  return bytesCount;
}

void _presupuestoSerialize(
  Presupuesto object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoria);
  writer.writeDateTime(offsets[1], object.fechaCreacion);
  writer.writeDouble(offsets[2], object.montoPresupuestado);
}

Presupuesto _presupuestoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Presupuesto(
    categoria: reader.readString(offsets[0]),
    fechaCreacion: reader.readDateTime(offsets[1]),
    montoPresupuestado: reader.readDouble(offsets[2]),
  );
  object.isarId = id;
  return object;
}

P _presupuestoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _presupuestoGetId(Presupuesto object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _presupuestoGetLinks(Presupuesto object) {
  return [];
}

void _presupuestoAttach(
    IsarCollection<dynamic> col, Id id, Presupuesto object) {
  object.isarId = id;
}

extension PresupuestoByIndex on IsarCollection<Presupuesto> {
  Future<Presupuesto?> getByCategoria(String categoria) {
    return getByIndex(r'categoria', [categoria]);
  }

  Presupuesto? getByCategoriaSync(String categoria) {
    return getByIndexSync(r'categoria', [categoria]);
  }

  Future<bool> deleteByCategoria(String categoria) {
    return deleteByIndex(r'categoria', [categoria]);
  }

  bool deleteByCategoriaSync(String categoria) {
    return deleteByIndexSync(r'categoria', [categoria]);
  }

  Future<List<Presupuesto?>> getAllByCategoria(List<String> categoriaValues) {
    final values = categoriaValues.map((e) => [e]).toList();
    return getAllByIndex(r'categoria', values);
  }

  List<Presupuesto?> getAllByCategoriaSync(List<String> categoriaValues) {
    final values = categoriaValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'categoria', values);
  }

  Future<int> deleteAllByCategoria(List<String> categoriaValues) {
    final values = categoriaValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'categoria', values);
  }

  int deleteAllByCategoriaSync(List<String> categoriaValues) {
    final values = categoriaValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'categoria', values);
  }

  Future<Id> putByCategoria(Presupuesto object) {
    return putByIndex(r'categoria', object);
  }

  Id putByCategoriaSync(Presupuesto object, {bool saveLinks = true}) {
    return putByIndexSync(r'categoria', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCategoria(List<Presupuesto> objects) {
    return putAllByIndex(r'categoria', objects);
  }

  List<Id> putAllByCategoriaSync(List<Presupuesto> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'categoria', objects, saveLinks: saveLinks);
  }
}

extension PresupuestoQueryWhereSort
    on QueryBuilder<Presupuesto, Presupuesto, QWhere> {
  QueryBuilder<Presupuesto, Presupuesto, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PresupuestoQueryWhere
    on QueryBuilder<Presupuesto, Presupuesto, QWhereClause> {
  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> categoriaEqualTo(
      String categoria) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoria',
        value: [categoria],
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterWhereClause> categoriaNotEqualTo(
      String categoria) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [],
              upper: [categoria],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [categoria],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [categoria],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [],
              upper: [categoria],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PresupuestoQueryFilter
    on QueryBuilder<Presupuesto, Presupuesto, QFilterCondition> {
  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoria',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoria',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      categoriaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      fechaCreacionEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      fechaCreacionGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      fechaCreacionLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      fechaCreacionBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaCreacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      montoPresupuestadoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'montoPresupuestado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      montoPresupuestadoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'montoPresupuestado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      montoPresupuestadoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'montoPresupuestado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterFilterCondition>
      montoPresupuestadoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'montoPresupuestado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PresupuestoQueryObject
    on QueryBuilder<Presupuesto, Presupuesto, QFilterCondition> {}

extension PresupuestoQueryLinks
    on QueryBuilder<Presupuesto, Presupuesto, QFilterCondition> {}

extension PresupuestoQuerySortBy
    on QueryBuilder<Presupuesto, Presupuesto, QSortBy> {
  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> sortByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> sortByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> sortByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      sortByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      sortByMontoPresupuestado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoPresupuestado', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      sortByMontoPresupuestadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoPresupuestado', Sort.desc);
    });
  }
}

extension PresupuestoQuerySortThenBy
    on QueryBuilder<Presupuesto, Presupuesto, QSortThenBy> {
  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> thenByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> thenByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> thenByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      thenByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      thenByMontoPresupuestado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoPresupuestado', Sort.asc);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QAfterSortBy>
      thenByMontoPresupuestadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoPresupuestado', Sort.desc);
    });
  }
}

extension PresupuestoQueryWhereDistinct
    on QueryBuilder<Presupuesto, Presupuesto, QDistinct> {
  QueryBuilder<Presupuesto, Presupuesto, QDistinct> distinctByCategoria(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoria', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QDistinct> distinctByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaCreacion');
    });
  }

  QueryBuilder<Presupuesto, Presupuesto, QDistinct>
      distinctByMontoPresupuestado() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'montoPresupuestado');
    });
  }
}

extension PresupuestoQueryProperty
    on QueryBuilder<Presupuesto, Presupuesto, QQueryProperty> {
  QueryBuilder<Presupuesto, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Presupuesto, String, QQueryOperations> categoriaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoria');
    });
  }

  QueryBuilder<Presupuesto, DateTime, QQueryOperations>
      fechaCreacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaCreacion');
    });
  }

  QueryBuilder<Presupuesto, double, QQueryOperations>
      montoPresupuestadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'montoPresupuestado');
    });
  }
}
