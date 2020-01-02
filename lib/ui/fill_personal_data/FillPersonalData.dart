import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/ui/fill_personal_data/FillPersonalDataDelegate.dart';
import 'package:digimagz/ui/fill_personal_data/FillPersonalDataPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FillPersonalData extends StatefulWidget {
  final state = _FillPersonalDataState();
  @override
  _FillPersonalDataState createState() => state;
}

class _FillPersonalDataState extends BaseState<FillPersonalData, FillPersonalDataPresenter>
    implements FillPersonalDataDelegate{
  TextEditingController _dateController = TextEditingController();

  int _selectedGender = 0;

  @override
  FillPersonalDataPresenter initPresenter() => FillPersonalDataPresenter(this, this);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: false,
          backgroundColor: Colors.white,
          title: StyledText("Lengkapi Data Pribadi"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => finish(result: false),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(adaptiveWidth(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText("Sebelum melanjutkan, mohon untuk mengisi data berikut",
                size: adaptiveWidth(context, 14),
              ),
              SizedBox(height: adaptiveWidth(context, 5)),
              GestureDetector(
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if(date != null){
                    _dateController.text = DateFormat("dd MMMM yyyy").format(date);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: TextFormField(
                  enabled: false,
                  controller: _dateController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorUtils.primary),
                    ),
                    labelText: "Tanggal Lahir",
                    labelStyle: TextStyle(
                      color: ColorUtils.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: adaptiveWidth(context, 15)),
              StyledText("Jenis Kelamin",
                size: adaptiveWidth(context, 12),
                color: Colors.grey,
              ),
              SizedBox(height: adaptiveWidth(context, 5)),
              Row(
                children: <Widget>[
                  Radio(value: 0,
                    groupValue: _selectedGender,
                    onChanged: (it) => setState(() => _selectedGender = it),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: ColorUtils.primary,
                  ),
                  StyledText("Laki - laki",
                    size: adaptiveWidth(context, 12),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(value: 1,
                    groupValue: _selectedGender,
                    onChanged: (it) => setState(() => _selectedGender = it),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: ColorUtils.primary,
                  ),
                  StyledText("Perempuan",
                    size: adaptiveWidth(context, 12),
                  )
                ],
              ),
              SizedBox(height: adaptiveWidth(context, 15)),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () => presenter.executeUpdateProfile(_dateController.text,
                      _selectedGender == 0 ? "L" : "P"),
                  color: ColorUtils.primary,
                  height: adaptiveWidth(context, 40),
                  child: StyledText("SIMPAN",
                    size: adaptiveWidth(context, 14),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        finish(result: false);
        return false;
      },
    );
  }

  @override
  void onSuccessChangePersonalData() => finish(result: true);

}
