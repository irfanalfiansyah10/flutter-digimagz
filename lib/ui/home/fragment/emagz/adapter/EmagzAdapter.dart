import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:digimagz/extension/Size.dart';

class EmagzItem extends StatelessWidget {
  final EmagzData data;

  EmagzItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: UrlUtils.URL_IMAGE_EMAGZ + data.thumbnail,
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
            ),
            SizedBox(height: adaptiveWidth(context, 10)),
            MaterialButton(
              onPressed: (){},
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
                  )
                ]
              )
            )
          ]
        )
      )
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

