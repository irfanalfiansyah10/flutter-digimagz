import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadProvider extends ChangeNotifier{
  Map<String, int> _progressTasks = Map();
  Map<String, DownloadTaskStatus> _statusTasks = Map();

  void update(String taskId, int progress, DownloadTaskStatus status){
    _progressTasks[taskId] = progress;
    _statusTasks[taskId] = status;
    notifyListeners();
  }

  void remove(DownloadTask task){
    _progressTasks.remove(task.taskId);
    _statusTasks.remove(task.taskId);
    notifyListeners();
  }

  bool contains(DownloadTask task) =>
      _progressTasks.containsKey(task.taskId) && _statusTasks.containsKey(task.taskId);

  int getProgress(DownloadTask task) => _progressTasks[task.taskId];
  DownloadTaskStatus getStatus(DownloadTask task) => _statusTasks[task.taskId];
}