import 'package:digimagz/database/tables.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'db.g.dart';

@UseMoor(
  tables: [DownloadedEbooks],
)
class MyDatabase extends _$MyDatabase {
  static MyDatabase _instance;

  MyDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite"));

  static MyDatabase instance(){
    if(_instance == null){
      _instance = MyDatabase();
    }

    return _instance;
  }

  @override
  int get schemaVersion => 1;

  Future<DownloadedEbook> getEbookByIdUrl(String idUrl) =>
      (select(downloadedEbooks)..where((it) => it.idEmagz.equals(idUrl))).getSingle();

  void insertToDownloadedEbooks(String idUrl, String path){
    into(downloadedEbooks).insert(DownloadedEbooksCompanion(
      idEmagz: Value(idUrl),
      path: Value(path)
    ));
  }
}