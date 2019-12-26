import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragmentDelegate.dart';

class EmagzFragmentPresenter extends BasePresenter{
  final EmagzFragmentDelegate _delegate;

  EmagzFragmentPresenter(BaseState state, this._delegate) : super(state);


}