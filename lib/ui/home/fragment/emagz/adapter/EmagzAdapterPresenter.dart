import 'dart:io';

import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/provider/DownloadEbookProvider.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EmagzAdapterPresenter extends BasePresenter{
  static const REQUEST_DOWNLOAD_EBOOK = 0;

  EmagzAdapterPresenter(BaseState state) : super(state);

  void checkDownload(EmagzData data, DownloadEbookProvider provider) async {
    var ebook = await db.getEbookByIdUrl(data.idEmagz);
    if (ebook != null) {
      provider.alreadyDownloaded(data.idEmagz, DownloadEbookTask.fromDownloadedEbooksTable(ebook));
    }
  }

  void downloadEbook(EmagzData data, DownloadEbookProvider provider) async {
    var isPermissionGranted = true;
    if (Platform.isAndroid) {
      isPermissionGranted = await _checkStoragePermission();
    }

    if (isPermissionGranted) {
      var fileName = data.file.split("/").last;
      var pathDir = "";

      if (Platform.isIOS) {
        pathDir = (await getApplicationDocumentsDirectory()).path + "/" + fileName;
      } else {
        pathDir = (await getExternalStorageDirectory()).path + "/" + fileName;
      }

      var cancelToken = CancelToken();

      provider.startDownload(data.idEmagz, pathDir, cancelToken);

      repository.download(REQUEST_DOWNLOAD_EBOOK, UrlUtils.URL_FILES_EMAGZ+data.file, pathDir,
              (count, total) {
            provider.updateProgress(data.idEmagz, count, total);

            if (count >= total) {
              db.insertToDownloadedEbooks(data.idEmagz, pathDir);
            }
          }, cancelToken: cancelToken);
    }
  }

  void open(DownloadEbookTask task) async {
    await OpenFile.open(task.path);
  }

  void cancel(EmagzData data, DownloadEbookProvider provider){
    provider.cancel(data.idEmagz);
  }

  Future<bool> _checkStoragePermission() async {
    var handler = PermissionHandler();

    var status = await handler.checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      var request = await handler.requestPermissions([PermissionGroup.storage]);
      if (request[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      } else {
        if (!await handler
            .shouldShowRequestPermissionRationale(PermissionGroup.storage)) {
          state.alert(
              title: "Perizinan",
              message: "Izin mengakses storage dibutuhkan untuk mendownload file",
              positiveTitle: "Pergi Ke Settings",
              onPositive: () async => handler.openAppSettings());
        } else {
          state.alert(
              title: "Perizinan",
              message: "Izin mengakses storage dibutuhkan untuk mendownload file",
              positiveTitle: "Tutup");
        }
        return false;
      }
    }

    return false;
  }
}