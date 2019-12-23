import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/dialog/EditNamaDialog.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

class ProfileFragment extends BaseStatefulWidget {

  final state = _ProfileFragmentState();

  @override
  _ProfileFragmentState createState() => state;

}

class _ProfileFragmentState extends BaseState<ProfileFragment> implements ProfileFragmentDelegate{
  ProfileFragmentPresenter _presenter;
  RequestWrapper<User> _userWrapper = RequestWrapper();

  String _currentName = "";

  @override
  void initState() {
    super.initState();
    _presenter = ProfileFragmentPresenter(this, this);

    _userWrapper.subscribe((value){
      if(value != null) {
        _currentName = value.userName;
      }
    });
  }

  @override
  void afterWidgetBuilt() {
    _presenter.getAccount(_userWrapper);
  }

  void onEdit(String name){
    _presenter.updateName(name, _userWrapper);
  }

  @override
  void onEditSuccess(User newUser) async {
    Fluttertoast.showToast(msg: "Nama Profil berhasil diperbarui");
    await AppPreference.saveUser(newUser);
  }

  @override
  void onSuccessLogout() {
    navigateTo(MyApp.ROUTE_HOME, singleTop: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: adaptiveWidth(context, 250),
          color: Colors.grey,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                RequestWrapperWidget(
                  requestWrapper: _userWrapper,
                  placeholder: Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 120),
                      height: adaptiveWidth(context, 120),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  builder: (ctx, data){
                    var user = data as User;
                    return CachedNetworkImage(
                      imageUrl: user.urlPic,
                      imageBuilder: (ctx, provider) => Container(
                        width: adaptiveWidth(context, 120),
                        height: adaptiveWidth(context, 120),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: provider,
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.circle
                        ),
                      ),
                      placeholder: (ctx, url) => Shimmer.fromColors(
                        child: Container(
                          width: adaptiveWidth(context, 120),
                          height: adaptiveWidth(context, 120),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: adaptiveWidth(context, -12.5),
                  right: adaptiveWidth(context, -2.5),
                  child: Container(
                    width: adaptiveWidth(context, 50),
                    height: adaptiveWidth(context, 50),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorUtils.primary
                    ),
                    child: Center(
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: adaptiveWidth(context, 15)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: adaptiveWidth(context, 10),
              horizontal: adaptiveWidth(context, 20)),
          child: Row(
            children: <Widget>[
              Icon(Icons.person, color: ColorUtils.primary, size: 40,),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Nama", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      )),
                      builder: (ctx, data){
                        var user = data as User;
                        return Text(user.userName, textScaleFactor: 1.0, style: TextStyle(
                            color: Colors.black,
                            fontSize: 12
                        ));
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: ColorUtils.primary,
                iconSize: 26,
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (ctx) => EditNamaDialog(_currentName, onEdit)
                  );
                },
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: adaptiveWidth(context, 10),
              horizontal: adaptiveWidth(context, 20)),
          child: Row(
            children: <Widget>[
              Icon(Icons.email, color: ColorUtils.primary, size: 40,),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Email", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      )),
                      builder: (ctx, data){
                        var user = data as User;
                        return Text(user.email, textScaleFactor: 1.0, style: TextStyle(
                            color: Colors.black,
                            fontSize: 12
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: adaptiveWidth(context, 10),
              horizontal: adaptiveWidth(context, 20)),
          child: Row(
            children: <Widget>[
              Icon(Icons.phone, color: ColorUtils.primary, size: 40,),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Telepon", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      )),
                      builder: (ctx, data) => Text("-", textScaleFactor: 1.0, style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MaterialButton(
            color: ColorUtils.primary,
            onPressed: () => _presenter.logout(),
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
            ),
            child: Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }
}
