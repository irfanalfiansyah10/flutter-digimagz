import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:digimagz/utilities/ImageUtils.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapterPresenter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NewsItem extends StatefulWidget {

  final News news;
  final Function(News) onNewsSelected;

  NewsItem(this.news, this.onNewsSelected);

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends BaseState<NewsItem, NewsAdapterPresenter> {
  RequestWrapper<bool> _likeWrapper = RequestWrapper(initialValue: false);

  @override
  NewsAdapterPresenter initPresenter() => NewsAdapterPresenter(this);

  @override
  void initState() {
    super.initState();
    _likeWrapper.subscribeOnFinishedAndNonNull((r){
      if(r){
        Provider.of<LikeProvider>(context).alreadyLiked(widget.news);
      }
    });
  }

  @override
  void afterWidgetBuilt() => presenter.executeCheckLike(_likeWrapper, widget.news.idNews);

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void onRequestTimeOut(int typeRequest) =>
      delay(5000, () => presenter.executeCheckLike(_likeWrapper, widget.news.idNews));

  @override
  void onNoConnection(int typeRequest) =>
      delay(5000, () => presenter.executeCheckLike(_likeWrapper, widget.news.idNews));

  @override
  void onUnknownError(int typeRequest, String msg) =>
      delay(5000, () => presenter.executeCheckLike(_likeWrapper, widget.news.idNews));

  @override
  void onResponseError(int typeRequest, ResponseException exception) {}

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: (){
          widget.onNewsSelected(widget.news);
        },
        child: Container(
          width: double.infinity,
          height: adaptiveWidth(context, 130),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.news.newsImage.length > 0 ? widget.news.newsImage[0] : "",
                imageBuilder: (ctx, provider) => Container(
                  width: adaptiveWidth(context, 130),
                  height: adaptiveWidth(context, 130),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (ctx, url) => Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 130),
                      height: adaptiveWidth(context, 130),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white
                ),
                errorWidget: (_, __, ___) => Container(
                  width: adaptiveWidth(context, 130),
                  height: adaptiveWidth(context, 130),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageUtils.mqdefault),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(widget.news.titleNews,
                        textScaleFactor: 1.0,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time, color: ColorUtils.primary),
                        SizedBox(width: 5),
                        Text(DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd HH:mm:ss")
                            .parse(widget.news.dateNews)),
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12
                          ),
                        ),

                        Spacer(),

                        Icon(Icons.chat_bubble_outline, color: ColorUtils.primary),
                        SizedBox(width: 5),
                        Text(widget.news.comments,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12
                          ),
                        ),

                        SizedBox(width: 10),

                        Consumer<LikeProvider>(
                          builder: (_, provider, __){
                            if(provider.likedNews.contains(widget.news.idNews)){
                              return Icon(Icons.favorite, color: ColorUtils.primary);
                            }

                            return Icon(Icons.favorite_border, color: ColorUtils.primary);
                          },
                        ),
                        SizedBox(width: 5),
                        Consumer<LikeProvider>(
                          builder: (_, provider, __) => Text(provider.getNumberOfLike(widget.news),
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ShimmerNewsItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        height: adaptiveWidth(context, 130),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Shimmer.fromColors(
                child: Container(
                  width: adaptiveWidth(context, 130),
                  height: adaptiveWidth(context, 130),
                  color: Colors.grey[300],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Shimmer.fromColors(
                      child: Container(
                        width: double.infinity,
                        height: adaptiveWidth(context, 15),
                        color: Colors.grey[300],
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.white),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                      child: Container(
                        width: double.infinity,
                        height: adaptiveWidth(context, 15),
                        color: Colors.grey[300],
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.white),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Shimmer.fromColors(
                          child: Container(
                            width: adaptiveWidth(context, 80),
                            height: adaptiveWidth(context, 15),
                            color: Colors.grey[300],
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.white),

                      Spacer(),

                      Shimmer.fromColors(
                          child: Container(
                            width: adaptiveWidth(context, 80),
                            height: adaptiveWidth(context, 15),
                            color: Colors.grey[300],
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.white)
                      ,

                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
