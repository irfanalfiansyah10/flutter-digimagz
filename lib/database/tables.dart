import 'package:moor_flutter/moor_flutter.dart';

class DownloadedEbooks extends Table{
  TextColumn get idEmagz => text()();
  TextColumn get path => text()();

  @override
  Set<Column> get primaryKey => {idEmagz};
}