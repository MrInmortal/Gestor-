// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_ahorro.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMetaAhorroCollection on Isar {
  IsarCollection<MetaAhorro> get metaAhorros => this.collection();
}

const MetaAhorroSchema = CollectionSchema(
  name: r'MetaAhorro',
  id: -8009384059420939096,
  properties: {
    r'fechaCreacion': PropertySchema(
      id: 0,
      name: r'fechaCreacion',
      type: IsarType.dateTime,
    ),
    r'fechaLimite': PropertySchema(
      id: 1,
      name: r'fechaLimite',
      type: IsarType.dateTime,
    ),
    r'montoAhorrado': PropertySchema(
      id: 2,
      name: r'montoAhorrado',
      type: IsarType.double,
    ),
    r'montoObjetivo': PropertySchema(
      id: 3,
      name: r'montoObjetivo',
      type: IsarType.double,
    ),
    r'nombre': PropertySchema(
      id: 4,
      name: r'nombre',
      type: IsarType.string,
    )
  },
  estimateSize: _metaAhorroEstimateSize,
  serialize: _metaAhorroSerialize,
  deserialize: _metaAhorroDeserialize,
  deserializeProp: _metaAhorroDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _metaAhorroGetId,
  getLinks: _metaAhorroGetLinks,
  attach: _metaAhorroAttach,
  version: '3.1.0+1',
);

int _metaAhorroEstimateSize(
  MetaAhorro object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nombre.length * 3;
  return bytesCount;
}

void _metaAhorroSerialize(
  MetaAhorro object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.fechaCreacion);
  writer.writeDateTime(offsets[1], object.fechaLimite);
  writer.writeDouble(offsets[2], object.montoAhorrado);
  writer.writeDouble(offsets[3], object.montoObjetivo);
  writer.writeString(offsets[4], object.nombre);
}

MetaAhorro _metaAhorroDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MetaAhorro(
    montoAhorrado: reader.readDoubleOrNull(offsets[2]) ?? 0.0,
  );
  object.fechaCreacion = reader.readDateTime(offsets[0]);
  object.fechaLimite = reader.readDateTime(offsets[1]);
  object.isarId = id;
  object.montoObjetivo = reader.readDouble(offsets[3]);
  object.nombre = reader.readString(offsets[4]);
  return object;
}

P _metaAhorroDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _metaAhorroGetId(MetaAhorro object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _metaAhorroGetLinks(MetaAhorro object) {
  return [];
}

void _metaAhorroAttach(IsarCollection<dynamic> col, Id id, MetaAhorro object) {
  object.isarId = id;
}

extension MetaAhorroQueryWhereSort
    on QueryBuilder<MetaAhorro, MetaAhorro, QWhere> {
  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MetaAhorroQueryWhere
    on QueryBuilder<MetaAhorro, MetaAhorro, QWhereClause> {
  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterWhereClause> isarIdBetween(
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
}

extension MetaAhorroQueryFilter
    on QueryBuilder<MetaAhorro, MetaAhorro, QFilterCondition> {
  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      fechaCreacionEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaCreacion',
        value: value,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      fechaLimiteEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaLimite',
        value: value,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      fechaLimiteGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaLimite',
        value: value,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      fechaLimiteLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaLimite',
        value: value,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      fechaLimiteBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaLimite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoAhorradoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'montoAhorrado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoAhorradoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'montoAhorrado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoAhorradoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'montoAhorrado',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoAhorradoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'montoAhorrado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoObjetivoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'montoObjetivo',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoObjetivoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'montoObjetivo',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoObjetivoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'montoObjetivo',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      montoObjetivoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'montoObjetivo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition> nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterFilterCondition>
      nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }
}

extension MetaAhorroQueryObject
    on QueryBuilder<MetaAhorro, MetaAhorro, QFilterCondition> {}

extension MetaAhorroQueryLinks
    on QueryBuilder<MetaAhorro, MetaAhorro, QFilterCondition> {}

extension MetaAhorroQuerySortBy
    on QueryBuilder<MetaAhorro, MetaAhorro, QSortBy> {
  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByFechaLimite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaLimite', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByFechaLimiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaLimite', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByMontoAhorrado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoAhorrado', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByMontoAhorradoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoAhorrado', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByMontoObjetivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoObjetivo', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByMontoObjetivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoObjetivo', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension MetaAhorroQuerySortThenBy
    on QueryBuilder<MetaAhorro, MetaAhorro, QSortThenBy> {
  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByFechaCreacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaCreacion', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByFechaLimite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaLimite', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByFechaLimiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaLimite', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByMontoAhorrado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoAhorrado', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByMontoAhorradoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoAhorrado', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByMontoObjetivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoObjetivo', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByMontoObjetivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'montoObjetivo', Sort.desc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension MetaAhorroQueryWhereDistinct
    on QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> {
  QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> distinctByFechaCreacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaCreacion');
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> distinctByFechaLimite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaLimite');
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> distinctByMontoAhorrado() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'montoAhorrado');
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> distinctByMontoObjetivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'montoObjetivo');
    });
  }

  QueryBuilder<MetaAhorro, MetaAhorro, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }
}

extension MetaAhorroQueryProperty
    on QueryBuilder<MetaAhorro, MetaAhorro, QQueryProperty> {
  QueryBuilder<MetaAhorro, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MetaAhorro, DateTime, QQueryOperations> fechaCreacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaCreacion');
    });
  }

  QueryBuilder<MetaAhorro, DateTime, QQueryOperations> fechaLimiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaLimite');
    });
  }

  QueryBuilder<MetaAhorro, double, QQueryOperations> montoAhorradoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'montoAhorrado');
    });
  }

  QueryBuilder<MetaAhorro, double, QQueryOperations> montoObjetivoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'montoObjetivo');
    });
  }

  QueryBuilder<MetaAhorro, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }
}
