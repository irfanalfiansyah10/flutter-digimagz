import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/YoutubeResponse.dart';
import 'package:digimagz/ui/home/fragment/video/VideoFragmentDelegate.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class VideoItem extends StatelessWidget {
  final YoutubeVideo video;
  final VideoFragmentDelegate delegate;

  const VideoItem(this.video, this.delegate, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: video.urlDefaultThumbnail,
              imageBuilder: (ctx, provider) => Container(
                width: double.infinity,
                height: adaptiveWidth(context, 250),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: InkWell(
                    child: Image.asset("assets/images/button_play.png"),
                    onTap: (){
                      delegate.onPlayVideo(video);
                    },
                  ),
                ),
              ),
              placeholder: (ctx, url) => Shimmer.fromColors(
                  child: Container(
                    width: double.infinity,
                    height: adaptiveWidth(context, 250),
                    color: Colors.grey[300],
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.white
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(video.title,
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time, color: ColorUtils.primary),
                  SizedBox(width: 5),
                  Text(DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd")
                      .parse(video.datePublished.substring(0, 10))),
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  ),
                  Spacer(),
                  Card(
                    margin: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: (){
                        delegate.onRedirectYoutube(video);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/images/ic_youtube.svg",
                              width: 35, height: 25,),
                            SizedBox(width: 5),
                            Text("YouTube", textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: ColorUtils.redYoutube,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ShimmerVideoItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Shimmer.fromColors(
              child: Container(
                  width: double.infinity,
                  height: adaptiveWidth(context, 250),
                  color: Colors.grey[300],
                ),
              baseColor: Colors.grey[300],
              highlightColor: Colors.white,
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Shimmer.fromColors(
                child: Container(
                  width: adaptiveWidth(context, 250),
                  height: adaptiveWidth(context, 15),
                  color: Colors.grey[300],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Shimmer.fromColors(
                child: Container(
                  width: adaptiveWidth(context, 180),
                  height: adaptiveWidth(context, 15),
                  color: Colors.grey[300],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 75),
                      height: adaptiveWidth(context, 15),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  Spacer(),
                  Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 75),
                      height: adaptiveWidth(context, 45),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

