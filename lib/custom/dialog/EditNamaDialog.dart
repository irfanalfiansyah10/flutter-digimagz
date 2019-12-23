import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';

class EditNamaDialog extends StatelessWidget {
  final String currentName;
  final Function(String) onEdit;

  String changedName;

  EditNamaDialog(this.currentName, this.onEdit){
    changedName = currentName;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Edit Nama Profil", textScaleFactor:1.0, style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 15),
              TextFormField(
                initialValue: currentName,
                onChanged: (newValue){
                  changedName = newValue;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(child: MaterialButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      onEdit(changedName);
                    },
                    color: ColorUtils.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("Edit", style: TextStyle(color: Colors.white)),
                  )),
                  SizedBox(width: adaptiveWidth(context, 15)),
                  Expanded(child: MaterialButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    color: ColorUtils.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("Batal", style: TextStyle(color: Colors.white)),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
