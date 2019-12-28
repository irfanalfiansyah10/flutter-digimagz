import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/ui/fill_personal_data/FillPersonalDataPresenter.dart';
import 'package:flutter/material.dart';

class FillPersonalData extends StatefulWidget {
  @override
  _FillPersonalDataState createState() => _FillPersonalDataState();
}

class _FillPersonalDataState extends BaseState<FillPersonalData> {
  FillPersonalDataPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = FillPersonalDataPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
