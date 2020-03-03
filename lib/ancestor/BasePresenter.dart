import 'package:digimagz/database/db.dart';
import 'package:digimagz/network/request/RemoteRepository.dart';

import 'BaseState.dart';

class BasePresenter {
  final BaseState state;

  Repository repository;
  MyDatabase db;

  BasePresenter(this.state){
    repository = Repository(state);
    db = MyDatabase.instance();
  }
}