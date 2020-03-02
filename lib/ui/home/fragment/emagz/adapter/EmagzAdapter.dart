import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/provider/DownloadEbookProvider.dart';
import 'package:digimagz/ui/home/fragment/emagz/adapter/EmagzAdapterPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:digimagz/utilities/ImageUtils.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:digimagz/extension/Size.dart';

class EmagzItem extends StatefulWidget {
  final EmagzData data;

  EmagzItem({@required this.data});

  @override
  _EmagzItemState createState() => _EmagzItemState();
}

class _EmagzItemState extends BaseState<EmagzItem, EmagzAdapterPresenter> {
  static const CLOSE = -1;
  static const CANCEL = 0;

  DownloadEbookProvider _downloadEbookProvider;

  @override
  EmagzAdapterPresenter initPresenter() => EmagzAdapterPresenter(this);

  @override
  void afterWidgetBuilt(){
    _downloadEbookProvider = Provider.of<DownloadEbookProvider>(context);

    presenter.checkDownload(widget.data, _downloadEbookProvider);
  }

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: UrlUtils.URL_IMAGE_EMAGZ + widget.data.thumbnail,
              imageBuilder: (ctx, provider) => Container(
                width: double.infinity,
                height: adaptiveWidth(context, 130),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (ctx, url) => Shimmer.fromColors(
                child: Container(
                  width: double.infinity,
                  height: adaptiveWidth(context, 130),
                  color: Colors.grey[300],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ),
              errorWidget: (_, __, ___) => Container(
                width: double.infinity,
                height: adaptiveWidth(context, 130),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageUtils.mqdefault),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: adaptiveWidth(context, 10)),
            Consumer<DownloadEbookProvider>(
              builder: (_, provider, __) {
                if (provider.contains(widget.data.idEmagz)) {
                  var status = provider.getStatus(widget.data.idEmagz);

                  if (status == DownloadEbookStatus.PREPARING) {
                    return MaterialButton(
                      onPressed: () {},
                      color: ColorUtils.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StyledText("Mendownload...",
                            size: adaptiveWidth(context, 14),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    );
                  } else if (status == DownloadEbookStatus.DOWNLOADING) {
                    var task = provider.getTask(widget.data.idEmagz);
                    var current = task.current / 1000000;
                    var total = task.total / 1000000;

                    return MaterialButton(
                      onPressed: () async {
                        var result = await showCupertinoModalPopup<int>(
                          context: context,
                          builder: (_) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () => finish(result: CANCEL),
                                child: Text("Cancel"),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => finish(result: CLOSE),
                              child: Text("Close"),
                            ),
                          ),
                        );

                        if(result == CANCEL){
                          presenter.cancel(widget.data, provider);
                        }
                      },
                      color: ColorUtils.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StyledText("${current.toStringAsFixed(2)}MB / ${total
                              .toStringAsFixed(2)}MB",
                            size: adaptiveWidth(context, 14),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  } else if (status == DownloadEbookStatus.DOWNLOADED) {
                    return MaterialButton(
                      onPressed: () => presenter.open(provider.getTask(widget.data.idEmagz)),
                      color: ColorUtils.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StyledText("Open",
                            size: adaptiveWidth(context, 14),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    );
                  }
                }

                return MaterialButton(
                  onPressed: () => presenter.downloadEbook(widget.data, _downloadEbookProvider),
                  color: ColorUtils.primary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.file_download, color: Colors.white),
                      SizedBox(width: adaptiveWidth(context, 10)),
                      StyledText("Download",
                        size: adaptiveWidth(context, 14),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                );
              }
            ),
          ]
        ),
      ),
    );
  }
}


class ShimmerEmagz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
      ),
      baseColor: Colors.grey[300],
      highlightColor: Colors.white,
    );
  }
}

