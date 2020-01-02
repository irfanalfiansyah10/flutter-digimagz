import 'dart:ui';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/provider/DownloadProvider.dart';
import 'package:digimagz/ui/download_progress/DownloadProgressDelegate.dart';
import 'package:digimagz/ui/download_progress/DownloadProgressPresenter.dart';
import 'package:digimagz/ui/download_progress/adapter/DownloadedEmagzAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:provider/provider.dart';

class DownloadProgress extends StatefulWidget {
  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends BaseState<DownloadProgress, DownloadProgressPresenter>
    implements DownloadProgressDelegate{
  static const CLOSE = -1;
  static const PAUSE = 0;
  static const CANCEL = 1;
  static const OPEN = 2;
  static const REMOVE_TASK = 3;
  static const REMOVE_TASK_AND_FILE = 4;
  static const RETRY = 5;
  static const RESUME = 6;

  RequestWrapper<List<DownloadTask>> _downloadWrapper = RequestWrapper();
  DownloadProvider _provider;

  @override
  void afterWidgetBuilt() {
    _provider = Provider.of<DownloadProvider>(context);
    presenter.getDownloadedFile(_downloadWrapper, _provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text("Downloaded Emagz",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => finish(),
        ),
      ),
      body: RequestWrapperWidget<List<DownloadTask>>(
        requestWrapper: _downloadWrapper,
        placeholder: Container(),
        builder: (_, data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, index) => DownloadedEmagzItem(index: index,
            task: data[index],
            onSelected: onTaskSelected
          ),
        ),
      ),
    );
  }

  @override
  DownloadProgressPresenter initPresenter() => DownloadProgressPresenter(this);

  @override
  void onTaskSelected(DownloadTask task) async {
    var actions = <CupertinoActionSheetAction>[];
    var status = Provider.of<DownloadProvider>(context).contains(task) ?
      Provider.of<DownloadProvider>(context).getStatus(task) : task.status;

    if(status == DownloadTaskStatus.undefined){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: CANCEL),
        child: Text("Cancel"),
      ));
    }else if(status == DownloadTaskStatus.enqueued){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: CANCEL),
        child: Text("Cancel"),
      ));
    }else if(status == DownloadTaskStatus.running){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: PAUSE),
        child: Text("Pause"),
      ));
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: CANCEL),
        child: Text("Cancel"),
      ));
    }else if(status == DownloadTaskStatus.complete){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: OPEN),
        child: Text("Open File"),
      ));
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: REMOVE_TASK),
        child: Text("Remove Task"),
      ));
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: REMOVE_TASK_AND_FILE),
        child: Text("Remove Task & File"),
      ));
    }else if(status == DownloadTaskStatus.failed || status == DownloadTaskStatus.canceled){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: RETRY),
        child: Text("Retry"),
      ));
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: REMOVE_TASK),
        child: Text("Remove Task"),
      ));
    }else if(status == DownloadTaskStatus.paused){
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: RESUME),
        child: Text("Resume"),
      ));
      actions.add(CupertinoActionSheetAction(
        onPressed: () => finish(result: REMOVE_TASK),
        child: Text("Remove Task"),
      ));
    }

    var result = await showCupertinoModalPopup<int>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => finish(result: CLOSE),
          child: Text("Close"),
        ),
      ),
    );

    if(result == PAUSE){
      presenter.pauseTask(task, _downloadWrapper, _provider);
    }else if(result == CANCEL){
      presenter.cancelTask(task, _downloadWrapper, _provider);
    }else if(result == OPEN){
      presenter.openTask(task);
    }else if(result == REMOVE_TASK){
      presenter.removeTask(task, _downloadWrapper, _provider);
    }else if(result == REMOVE_TASK_AND_FILE){
      presenter.removeTaskAndFile(task, _downloadWrapper, _provider);
    }else if(result == RETRY){
      presenter.retryTask(task, _downloadWrapper, _provider);
    }else if(result == RESUME){
      presenter.resumeTask(task, _downloadWrapper, _provider);
    }
  }
}
