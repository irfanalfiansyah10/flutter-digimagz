import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/provider/DownloadProvider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:open_file/open_file.dart';

class DownloadProgressPresenter extends BasePresenter {
  DownloadProgressPresenter(BaseState state) : super(state);

  void getDownloadedFile(RequestWrapper<List<DownloadTask>> wrapper, DownloadProvider provider) async {
    wrapper.doRequestKeepState();

    var tasks = await FlutterDownloader.loadTasks();
    tasks.forEach((it){
      if(it.status != DownloadTaskStatus.enqueued && it.status != DownloadTaskStatus.running){
        if(provider.contains(it)){
          provider.remove(it);
        }
      }
    });

    wrapper.finishRequest(tasks);
  }

  void pauseTask(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.pause(taskId: task.taskId);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }

  void cancelTask(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.cancel(taskId: task.taskId);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }

  void openTask(DownloadTask task){
    OpenFile.open(task.savedDir.replaceAll("(null)", "")+task.filename);
  }

  void removeTask(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.remove(taskId: task.taskId);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }

  void removeTaskAndFile(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.remove(taskId: task.taskId, shouldDeleteContent: true);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }

  void retryTask(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.retry(taskId: task.taskId);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }

  void resumeTask(DownloadTask task, RequestWrapper<List<DownloadTask>> wrapper,
      DownloadProvider provider) async {
    provider.remove(task);

    wrapper.doRequestKeepState();
    await FlutterDownloader.resume(taskId: task.taskId);
    wrapper.finishRequest(await FlutterDownloader.loadTasks());
  }
}