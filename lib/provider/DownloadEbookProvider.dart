import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:digimagz/database/db.dart';

class DownloadEbookProvider extends ChangeNotifier{
  Map<String, DownloadEbookTask> _downloadTask = Map();

  void startDownload(String idEmagz, String path, CancelToken cancelToken){
    if(!_downloadTask.containsKey(idEmagz)){
      _downloadTask[idEmagz] = DownloadEbookTask(idEmagz: idEmagz,
          path: path, cancelToken: cancelToken);
      notifyListeners();
    }
  }

  void updateProgress(String idEmagz, int current, int total){
    if(_downloadTask.containsKey(idEmagz)){
      _downloadTask[idEmagz].updateProgress(current, total);
      notifyListeners();
    }
  }

  void cancel(String idEmagz){
    if(_downloadTask.containsKey(idEmagz)){
      _downloadTask[idEmagz].cancelToken.cancel();
      _downloadTask.remove(idEmagz);
      notifyListeners();
    }
  }

  void alreadyDownloaded(String idEmagz, DownloadEbookTask task){
    _downloadTask[idEmagz] = task;
    notifyListeners();
  }

  bool contains(String idEmagz) => _downloadTask.containsKey(idEmagz);

  DownloadEbookTask getTask(String idEmagz) => _downloadTask[idEmagz];

  DownloadEbookStatus getStatus(String idEmagz) => _downloadTask[idEmagz].status;
}

class DownloadEbookTask {
  String idEmagz;
  int current;
  int total;
  String path;
  DownloadEbookStatus status;
  CancelToken cancelToken;

  DownloadEbookTask({@required this.idEmagz, @required this.path, @required this.cancelToken}){
    status = DownloadEbookStatus.PREPARING;
  }

  DownloadEbookTask.fromDownloadedEbooksTable(DownloadedEbook ebooks){
    idEmagz = ebooks.idEmagz;
    path = ebooks.path;
    status = DownloadEbookStatus.DOWNLOADED;
  }

  void updateProgress(int current, int total){
    this.current = current;
    this.total = total;

    if(current == total){
      status = DownloadEbookStatus.DOWNLOADED;
    }else {
      status = DownloadEbookStatus.DOWNLOADING;
    }
  }
}

enum DownloadEbookStatus{
  PREPARING, DOWNLOADING, DOWNLOADED, CANCELLED
}