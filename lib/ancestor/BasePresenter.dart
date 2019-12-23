import 'package:digimagz/network/request/RemoteRepository.dart';

import 'BaseState.dart';

class BasePresenter {
  final BaseState state;

  Repository repository;

  BasePresenter(this.state){
    repository = Repository(state);
  }
}