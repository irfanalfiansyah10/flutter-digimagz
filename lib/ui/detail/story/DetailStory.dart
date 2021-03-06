import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/utilities/ImageUtils.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/network/response/StoryResponse.dart';
import 'package:digimagz/ui/detail/story/DetailStoryDelegate.dart';
import 'package:digimagz/ui/detail/story/DetailStoryPresenter.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailStory extends StatefulWidget {
  final Story story;

  DetailStory(this.story);

  @override
  _DetailStoryState createState() => _DetailStoryState();
}

class _DetailStoryState extends BaseState<DetailStory, DetailStoryPresenter>
    implements DetailStoryDelegate{
  RequestWrapper<NewsResponse> _relatedNewsWrapper = RequestWrapper();

  @override
  DetailStoryPresenter initPresenter() => DetailStoryPresenter(this);

  @override
  void initState() {
    super.initState();
    presenter.executeGetRelatedNews(widget.story.idCoverStory, _relatedNewsWrapper);
  }

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void onRequestTimeOut(int typeRequest) {
    if(typeRequest == DetailStoryPresenter.REQUEST_GET_RELATED_NEWS){
      delay(5000, () => presenter.executeGetRelatedNews(widget.story.idCoverStory, _relatedNewsWrapper));
    }else {
      super.onRequestTimeOut(typeRequest);
    }
  }

  @override
  void onNoConnection(int typeRequest) {
    if(typeRequest == DetailStoryPresenter.REQUEST_GET_RELATED_NEWS){
      delay(5000, () => presenter.executeGetRelatedNews(widget.story.idCoverStory, _relatedNewsWrapper));
    }else {
      super.onNoConnection(typeRequest);
    }
  }

  @override
  void onUnknownError(int typeRequest, String msg) {
    if(typeRequest == DetailStoryPresenter.REQUEST_GET_RELATED_NEWS){
      delay(5000, () => presenter.executeGetRelatedNews(widget.story.idCoverStory, _relatedNewsWrapper));
    }else {
      super.onUnknownError(typeRequest, msg);
    }
  }

  @override
  void onNewsSelected(News news) {
    navigateTo(MyApp.ROUTE_DETAIL_NEWS, arguments: news);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Image.asset("assets/images/logo_toolbar.png"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: (){
              finish();
            }
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: UrlUtils.URL_IMAGE_STORY+widget.story.imageCoverStory,
                imageBuilder: (ctx, provider) => Container(
                  width: double.infinity,
                  height: adaptiveWidth(context, 230),
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
                    height: adaptiveWidth(context, 230),
                    color: Colors.grey[300],
                  ),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.white,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: double.infinity,
                  height: adaptiveWidth(context, 230),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageUtils.mqdefault),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(widget.story.summaryIos,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: RequestWrapperWidget<NewsResponse>(
                  requestWrapper: _relatedNewsWrapper,
                  placeholder: (_) => Shimmer.fromColors(
                    child: Container(
                      color: Colors.grey[300],
                      height: adaptiveWidth(context, 16),
                      width: adaptiveWidth(context, 120),
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  builder: (_, data) => StyledText("${data.data.length} Story Pilihan",
                    size: adaptiveWidth(context, 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              RequestWrapperWidget<NewsResponse>(
                requestWrapper: _relatedNewsWrapper,
                placeholder: (_) => ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, position) => ShimmerNewsItem(),
                ),
                builder: (_, data) => ListView.builder(
                  itemCount: data.data.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, position) => NewsItem(data.data[position], onNewsSelected),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

