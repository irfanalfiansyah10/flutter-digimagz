import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/profile/ProfileFragmentPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileFragment extends StatefulWidget {

  final state = _ProfileFragmentState();

  @override
  _ProfileFragmentState createState() => state;

  void reload(){
    state.reload();
  }
}

class _ProfileFragmentState extends BaseState<ProfileFragment, ProfileFragmentPresenter>
    implements ProfileFragmentDelegate{
  static const CANCEL = -1;
  static const OPEN_CAMERA = 0;
  static const OPEN_GALLERY = 1;

  RequestWrapper<User> _userWrapper = RequestWrapper();

  @override
  ProfileFragmentPresenter initPresenter() => ProfileFragmentPresenter(this, this);

  @override
  void afterWidgetBuilt() {
    presenter.getAccount(_userWrapper);
  }

  @override
  void shouldHideLoading(int typeRequest) {
    if(typeRequest == ProfileFragmentPresenter.CHANGE_AVATAR){
      super.shouldHideLoading(typeRequest);
    }
  }

  @override
  void shouldShowLoading(int typeRequest) {
    if(typeRequest == ProfileFragmentPresenter.CHANGE_AVATAR){
      super.shouldShowLoading(typeRequest);
    }
  }

  @override
  void onSuccessChangeAvatar(BaseResponse response) {
    reload();
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
          height: adaptiveWidth(context, 180),
          color: ColorUtils.darkerGrey,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                RequestWrapperWidget<User>(
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
                  builder: (ctx, data) => CachedNetworkImage(
                    imageUrl: data.urlPic,
                    imageBuilder: (ctx, provider) => Container(
                      width: adaptiveWidth(context, 120),
                      height: adaptiveWidth(context, 120),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.contain,
                        ),
                        shape: BoxShape.circle,
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
                    errorWidget: (_, __, ___) => Container(
                      width: adaptiveWidth(context, 120),
                      height: adaptiveWidth(context, 120),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/missing_avatar.jpg"),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: adaptiveWidth(context, -12.5),
                  right: adaptiveWidth(context, -2.5),
                  child: InkWell(
                    onTap: () async {
                      var result = await showCupertinoModalPopup(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                          title: Text("Change Image Profile"),
                          message: Text("Choose options below"),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              onPressed: () => finish(result: OPEN_GALLERY),
                              child: Text("From Gallery"),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => finish(result: OPEN_CAMERA),
                              child: Text("From Camera"),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => finish(result: CANCEL),
                            child: Text("Cancel"),
                          ),
                        ),
                      );

                      File image;
                      if(result == OPEN_GALLERY){
                        image = await ImagePicker.pickImage(source: ImageSource.gallery);
                      }else if(result == OPEN_CAMERA){
                        image = await ImagePicker.pickImage(source: ImageSource.camera);
                      }

                      if(image != null){
                        presenter.executeChangeAvatar(image);
                      }
                    },
                    child: Container(
                      width: adaptiveWidth(context, 50),
                      height: adaptiveWidth(context, 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorUtils.primary,
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
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
                    RequestWrapperWidget<User>(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                      )),
                      builder: (ctx, data) => Text(data.userName, textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
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
              SizedBox(width: 40),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Jenis Kelamin", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget<User>(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                      builder: (ctx, data) => Text(data.gender, textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
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
              SizedBox(width: 40),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Tanggal Lahir", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget<User>(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                      builder: (ctx, data) => Text(data.dateBirth, textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
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
                    RequestWrapperWidget<User>(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                      builder: (ctx, data) => Text(data.email, textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
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
              SizedBox(width: 40),
              SizedBox(width: adaptiveWidth(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Status", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    )),
                    SizedBox(height: adaptiveWidth(context, 5)),
                    RequestWrapperWidget<User>(requestWrapper: _userWrapper,
                      placeholder: Text("", textScaleFactor: 1.0, style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                      builder: (ctx, data) => Text(data.userType, textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
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
            onPressed: (){
              presenter.logout();
              Provider.of<LikeProvider>(context).clear();
            },
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  void reload(){
    presenter.getAccountFromAPI(_userWrapper);
  }
}
