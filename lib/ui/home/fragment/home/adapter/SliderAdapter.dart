import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class SliderItem extends StatelessWidget {

  final News news;
  final Function(News) onNewsSelected;

  const SliderItem(this.news, this.onNewsSelected, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: UrlUtils.getUrlForImage(news),
                    imageBuilder: (ctx, provider) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (ctx, url) => Shimmer.fromColors(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[300],
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.white
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.black38,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(news.titleNews,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd HH:mm:ss")
                              .parse(news.dateNews)),
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onTap: (){
        onNewsSelected(news);
      },
    );
  }
}

