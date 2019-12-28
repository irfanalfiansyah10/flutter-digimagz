import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageNewsItem extends StatelessWidget {
  final News news;
  final int position;

  ImageNewsItem({@required this.news, @required this.position});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CachedNetworkImage(
        imageUrl: UrlUtils.getUrlForImage(news, position),
        imageBuilder: (ctx, provider) => Container(
          width: double.infinity,
          height: adaptiveWidth(context, 230),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: provider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (ctx, url) => Shimmer.fromColors(
          child: Container(
            width: double.infinity,
            height: adaptiveWidth(context, 230),
            color: Colors.grey[300],
          ),
          baseColor: Colors.grey[300],
          highlightColor: Colors.white,
        ),
      ),
    );
  }
}
