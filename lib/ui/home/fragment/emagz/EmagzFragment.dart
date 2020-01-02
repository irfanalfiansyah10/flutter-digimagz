import 'dart:isolate';
import 'dart:ui';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/provider/DownloadProvider.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/emagz/EmagzFragmentPresenter.dart';
import 'package:digimagz/ui/home/fragment/emagz/adapter/EmagzAdapter.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:mcnmr_wrap_height_gridview/WrapGrid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class EmagzFragment extends StatefulWidget {
  @override
  _EmagzFragmentState createState() => _EmagzFragmentState();
}

class _EmagzFragmentState extends BaseState<EmagzFragment, EmagzFragmentPresenter>
    implements EmagzFragmentDelegate{
  RequestWrapper<EmagzResponse> _emagzWrapper = RequestWrapper();
  DownloadProvider _provider;
  ReceivePort _port = ReceivePort();

  @override
  EmagzFragmentPresenter initPresenter() => EmagzFragmentPresenter(this, this);

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      _provider?.update(id, progress, status);
    });
  }

  @override
  void afterWidgetBuilt() {
    _provider = Provider.of<DownloadProvider>(context);
    presenter.executeGetEmagz(_emagzWrapper);
  }

  @override
  void onNoConnection(int typeRequest) => delay(5000, () => presenter.executeGetEmagz(_emagzWrapper));

  @override
  void onRequestTimeOut(int typeRequest) => delay(5000, () => presenter.executeGetEmagz(_emagzWrapper));

  @override
  void onUnknownError(int typeRequest, String msg) {}

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        presenter.executeGetEmagz(_emagzWrapper);
        await Future.delayed(Duration(seconds: 2));
      },
      child: RequestWrapperWidget<EmagzResponse>(
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
          builder: (_, index) => EmagzItem(data: data.data[index], onSelected: onDownloadStarted),
        ),
      ),
    );
  }

  @override
  void onDownloadStarted(EmagzData data) async{
    var folder = await getApplicationDocumentsDirectory();
    var fileName = DateTime.now().millisecondsSinceEpoch.toString()+"_"+data.file;

    await FlutterDownloader.enqueue(
      url: UrlUtils.URL_FILES_EMAGZ+data.file,
      savedDir: folder.path,
      fileName: fileName,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );

    alert(title: "Download",
      message: "Download dimulai, Anda bisa memantau download di menu pojok kanan atas",
      positiveTitle: "Tutup"
    );
  }
}
