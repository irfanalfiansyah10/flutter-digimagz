// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DownloadedEbook extends DataClass implements Insertable<DownloadedEbook> {
  final String idEmagz;
  final String path;
  DownloadedEbook({@required this.idEmagz, @required this.path});
  factory DownloadedEbook.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return DownloadedEbook(
      idEmagz: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}id_emagz']),
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
    );
  }
  factory DownloadedEbook.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DownloadedEbook(
      idEmagz: serializer.fromJson<String>(json['idEmagz']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idEmagz': serializer.toJson<String>(idEmagz),
      'path': serializer.toJson<String>(path),
    };
  }

  @override
  DownloadedEbooksCompanion createCompanion(bool nullToAbsent) {
    return DownloadedEbooksCompanion(
      idEmagz: idEmagz == null && nullToAbsent
          ? const Value.absent()
          : Value(idEmagz),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
    );
  }

  DownloadedEbook copyWith({String idEmagz, String path}) => DownloadedEbook(
        idEmagz: idEmagz ?? this.idEmagz,
        path: path ?? this.path,
      );
  @override
  String toString() {
    return (StringBuffer('DownloadedEbook(')
          ..write('idEmagz: $idEmagz, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(idEmagz.hashCode, path.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DownloadedEbook &&
          other.idEmagz == this.idEmagz &&
          other.path == this.path);
}

class DownloadedEbooksCompanion extends UpdateCompanion<DownloadedEbook> {
  final Value<String> idEmagz;
  final Value<String> path;
  const DownloadedEbooksCompanion({
    this.idEmagz = const Value.absent(),
    this.path = const Value.absent(),
  });
  DownloadedEbooksCompanion.insert({
    @required String idEmagz,
    @required String path,
  })  : idEmagz = Value(idEmagz),
        path = Value(path);
  DownloadedEbooksCompanion copyWith(
      {Value<String> idEmagz, Value<String> path}) {
    return DownloadedEbooksCompanion(
      idEmagz: idEmagz ?? this.idEmagz,
      path: path ?? this.path,
    );
  }
}

class $DownloadedEbooksTable extends DownloadedEbooks
    with TableInfo<$DownloadedEbooksTable, DownloadedEbook> {
  final GeneratedDatabase _db;
  final String _alias;
  $DownloadedEbooksTable(this._db, [this._alias]);
  final VerificationMeta _idEmagzMeta = const VerificationMeta('idEmagz');
  GeneratedTextColumn _idEmagz;
  @override
  GeneratedTextColumn get idEmagz => _idEmagz ??= _constructIdEmagz();
  GeneratedTextColumn _constructIdEmagz() {
    return GeneratedTextColumn(
      'id_emagz',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [idEmagz, path];
  @override
  $DownloadedEbooksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'downloaded_ebooks';
  @override
  final String actualTableName = 'downloaded_ebooks';
  @override
  VerificationContext validateIntegrity(DownloadedEbooksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.idEmagz.present) {
      context.handle(_idEmagzMeta,
          idEmagz.isAcceptableValue(d.idEmagz.value, _idEmagzMeta));
    } else if (isInserting) {
      context.missing(_idEmagzMeta);
    }
    if (d.path.present) {
      context.handle(
          _pathMeta, path.isAcceptableValue(d.path.value, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idEmagz};
  @override
  DownloadedEbook map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DownloadedEbook.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DownloadedEbooksCompanion d) {
    final map = <String, Variable>{};
    if (d.idEmagz.present) {
      map['id_emagz'] = Variable<String, StringType>(d.idEmagz.value);
    }
    if (d.path.present) {
      map['path'] = Variable<String, StringType>(d.path.value);
    }
    return map;
  }

  @override
  $DownloadedEbooksTable createAlias(String alias) {
    return $DownloadedEbooksTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DownloadedEbooksTable _downloadedEbooks;
  $DownloadedEbooksTable get downloadedEbooks =>
      _downloadedEbooks ??= $DownloadedEbooksTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [downloadedEbooks];
}
