import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragmentPresenter.dart';
import 'package:digimagz/ui/home/fragment/emagz/adapter/EmagzAdapter.dart';
import 'package:flutter/material.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:mcnmr_wrap_height_gridview/WrapGrid.dart';

class EmagzFragment extends StatefulWidget {
  @override
  _EmagzFragmentState createState() => _EmagzFragmentState();
}

class _EmagzFragmentState extends BaseState<EmagzFragment> implements EmagzFragmentDelegate{
  EmagzFragmentPresenter _presenter;
  RequestWrapper<EmagzResponse> _emagzWrapper = RequestWrapper();

  @override
  void initState() {
    super.initState();
    _presenter = EmagzFragmentPresenter(this, this);
  }

  @override
  void afterWidgetBuilt() {
    _presenter.executeGetEmagz(_emagzWrapper);
  }

  @override
  void onNoConnection(int typeRequest) => delay(5000, () => _presenter.executeGetEmagz(_emagzWrapper));

  @override
  void onRequestTimeOut(int typeRequest) => delay(5000, () => _presenter.executeGetEmagz(_emagzWrapper));

  @override
  void onUnknownError(int typeRequest, String msg) {}

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  Widget build(BuildContext context) {
    return RequestWrapperWidget<EmagzResponse>(
      requestWrapper: _emagzWrapper,
      placeholder: WrapGrid(
        isScrollable: true,
        rowAxisCount: 2,
        itemCount: 6,
        contentMargin: EdgeInsets.all(5),
        contentHeight: ContentHeight(height: adaptiveWidth(context, 200)),
        builder: (_, __) => ShimmerEmagz(),
      ),
      builder: (_, data) => WrapGrid(
        isScrollable: true,
        rowAxisCount: 2,
        itemCount: data.data.length,
        contentMargin: EdgeInsets.all(5),
        builder: (_, index) => EmagzItem(data: data.data[index]),
      ),
    );
  }
}
