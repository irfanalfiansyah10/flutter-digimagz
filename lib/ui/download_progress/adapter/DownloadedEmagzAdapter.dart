import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/provider/DownloadProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

class DownloadedEmagzItem extends StatelessWidget {
  final DownloadTask task;
  final int index;
  final Function(DownloadTask) onSelected;

  DownloadedEmagzItem({@required this.index, @required this.task, @required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(task),
      child: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: StyledText("${index+1}. ",
                    size: adaptiveWidth(context, 14),
                  ),
                  flex: 10,
                ),
                Expanded(
                  child: StyledText("${task.filename}",
                    size: adaptiveWidth(context, 14),
                  ),
                  flex: 65,
                ),
                Expanded(
                  child: Consumer<DownloadProvider>(
                    builder: (_, provider, __) => StyledText(_getStatus(provider),
                      size: adaptiveWidth(context, 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  flex: 25,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getStatus(DownloadProvider provider){
    var status = provider.contains(task) ? provider.getStatus(task) : task.status;

    if(status == DownloadTaskStatus.undefined){
      return "Undefined";
    }else if(status == DownloadTaskStatus.enqueued){
      return "Enqueued";
    }else if(status == DownloadTaskStatus.running){
      return provider.contains(task) ? "${provider.getProgress(task)}%" : "${task.progress}%";
    }else if(status == DownloadTaskStatus.complete){
      return "Completed";
    }else if(status == DownloadTaskStatus.failed){
      return "Failed";
    }else if(status == DownloadTaskStatus.canceled){
      return "Canceled";
    }else if(status == DownloadTaskStatus.paused){
      return "Paused";
    }
  }
}
