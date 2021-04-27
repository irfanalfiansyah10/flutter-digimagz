import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String applicationId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      applicationId = packageInfo.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: adaptiveWidth(context, 10),
            horizontal: adaptiveWidth(context, 20)),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                new Text(
                  "Aplikasi membutuhkan update untuk dapat menggunkana aplikasi secara penuh.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: MaterialButton(
                    color: ColorUtils.primary,
                    onPressed: (){
                      StoreRedirect.redirect(
                        androidAppId: applicationId,
                        iOSAppId: applicationId,
                      );
                    },
                    minWidth: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text("Update Sekarang", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )
        ),
      )
    );
  }
}
