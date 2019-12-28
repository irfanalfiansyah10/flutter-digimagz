import 'dart:async';

import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/pageIndicator/PageIndicator.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:digimagz/network/response/CommentResponse.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/preferences/AppPreference.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:digimagz/ui/detail/news/DetailNewsDelegate.dart';
import 'package:digimagz/ui/detail/news/DetailNewsPresenter.dart';
import 'package:digimagz/ui/detail/news/adapter/CommentAdapter.dart';
import 'package:digimagz/ui/detail/news/adapter/ImageNewsAdapter.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailNews extends StatefulWidget {
  final News news;

  DetailNews(this.news);

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends BaseState<DetailNews> implements DetailNewsDelegate{
  DetailNewsPresenter _presenter;
  RequestWrapper<NewsResponse> _relatedNewsWrapper = RequestWrapper();
  RequestWrapper<CommentResponse> _commentWrapper = RequestWrapper();
  RequestWrapper<bool> _isLikedWrapper = RequestWrapper<bool>(initialValue: false);

  User user;
  bool isUserLoggedIn = false;

  TextEditingController _commentController = TextEditingController();
  PageController _sliderController = PageController();

  int _currentSliderPosition = 0;
  Timer _automaticSlider;

  @override
  void initState() {
    super.initState();
    _presenter = DetailNewsPresenter(this, this);

    _isLikedWrapper.subscribeOnFinishedAndNonNull((r){
      if(r){
        Provider.of<LikeProvider>(context).addLike(widget.news);
      }else {
        Provider.of<LikeProvider>(context).removeLike(widget.news);
      }
    });
  }

  @override
  void afterWidgetBuilt() async {
    _presenter.executeGetRelatedNews(widget.news.idNews, _relatedNewsWrapper);

    _automaticSlider = Timer.periodic(Duration(seconds: 5), (_){
      if(_currentSliderPosition == widget.news.newsImage.length - 1){
        setState(() => _currentSliderPosition = 0);
        _sliderController.animateToPage(_currentSliderPosition,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        return;
      }
      setState(() => _currentSliderPosition++);
      _sliderController.animateToPage(_currentSliderPosition,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    });

    user = await AppPreference.getUser();

    if(user == null){
      _isLikedWrapper.finishRequest(false);
    }else {
      _presenter.executeCheckLike(widget.news.idNews, _isLikedWrapper);
      setState(() => isUserLoggedIn = true);
    }
  }

  @override
  void shouldShowLoading(int typeRequest) {
    if(typeRequest == DetailNewsPresenter.REQUEST_POST_COMMENT){
      super.shouldShowLoading(typeRequest);
    }
  }

  @override
  void shouldHideLoading(int typeRequest) {
    if(typeRequest == DetailNewsPresenter.REQUEST_POST_COMMENT){
      super.shouldHideLoading(typeRequest);
    }
  }

  @override
  void onNoConnection(int typeRequest) {
    if(typeRequest == DetailNewsPresenter.REQUEST_GET_RELATED_NEWS){
      delay(5000, () => _presenter.executeGetRelatedNews(widget.news.idNews, _relatedNewsWrapper));
    }else if(typeRequest == DetailNewsPresenter.REQUEST_GET_COMMENT){
      delay(5000, () => _presenter.executeGetComment(widget.news.idNews, _commentWrapper));
    }else if(typeRequest == DetailNewsPresenter.REQUEST_LIKE){
      delay(5000, (){
        if(_isLikedWrapper.result){
          _presenter.executeUnlike(widget.news.idNews, _isLikedWrapper);
          return;
        }
        _presenter.executeLike(widget.news.idNews, _isLikedWrapper);
      });
    }else {
      super.onNoConnection(typeRequest);
    }
  }

  @override
  void onRequestTimeOut(int typeRequest) {
    if(typeRequest == DetailNewsPresenter.REQUEST_GET_RELATED_NEWS){
      delay(5000, () => _presenter.executeGetRelatedNews(widget.news.idNews, _relatedNewsWrapper));
    }else if(typeRequest == DetailNewsPresenter.REQUEST_GET_COMMENT){
      delay(5000, () => _presenter.executeGetComment(widget.news.idNews, _commentWrapper));
    }else if(typeRequest == DetailNewsPresenter.REQUEST_LIKE){
      delay(5000, (){
        if(_isLikedWrapper.result){
          _presenter.executeUnlike(widget.news.idNews, _isLikedWrapper);
          return;
        }
        _presenter.executeLike(widget.news.idNews, _isLikedWrapper);
      });
    }else {
      super.onRequestTimeOut(typeRequest);
    }
  }


  @override
  void onResponseError(int typeRequest, ResponseException exception) {
    if(typeRequest != DetailNewsPresenter.REQUEST_LIKE){
      super.onResponseError(typeRequest, exception);
    }
  }

  void _onNewsSelected(News news){
    navigateTo(MyApp.ROUTE_DETAIL_NEWS, arguments: news);
  }

  @override
  void onSuccessLike() {
    setState(() {
      widget.news.likes = (int.parse(widget.news.likes) + 1).toString();
    });
  }

  @override
  void onSuccessDislike() {
    setState(() {
      widget.news.likes = (int.parse(widget.news.likes) - 1).toString();
    });
  }

  @override
  void onSuccessPostComment() {
    Fluttertoast.showToast(msg: "Terima kasih atas komentar anda dan sedang kami moderasi");
    _commentController.text = "";
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
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            finish();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(widget.news.titleNews,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.bookmark_border, color: ColorUtils.primary),
                      SizedBox(width: 5),
                      Text(widget.news.nameCategory,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      Spacer(),

                      Icon(Icons.access_time, color: ColorUtils.primary),
                      SizedBox(width: 5),
                      Text(DateFormat("dd MMM yyyy").format(DateFormat("yyyy-MM-dd HH:mm:ss")
                          .parse(widget.news.dateNews)),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: adaptiveWidth(context, 230),
                  width: double.infinity,
                  child: PageView(
                    controller: _sliderController,
                    onPageChanged: (i) => setState(() => _currentSliderPosition = i),
                    children: widget.news.newsImage.asMap()
                        .map((index, element) => MapEntry(index, ImageNewsItem(news: widget.news, position: index)))
                        .values.toList(),
                  )
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.news.newsImage.asMap()
                      .map((index, element) => MapEntry(
                      index,
                      PageIndicator(_currentSliderPosition == index,
                      activeColor: ColorUtils.primary))).values.toList(),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: HtmlWidget(
                    widget.news.contentNews,
                    webView: true,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Visibility(
                        visible: widget.news.editor != "",
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit, color: ColorUtils.primary),
                            SizedBox(width: 5),
                            Text(widget.news.editor,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Spacer(),

                      Visibility(
                        visible: widget.news.verificator != "",
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.beenhere, color: ColorUtils.primary),
                            SizedBox(width: 5),
                            Text(widget.news.verificator,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: RequestWrapperWidget(
                            requestWrapper: _isLikedWrapper,
                            placeholder: Shimmer.fromColors(
                              child: Container(
                                width: 24,
                                height: 24,
                                color: Colors.grey[300],
                              ),
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.white,
                            ),
                            builder: (ctx, data) => Consumer<LikeProvider>(
                              builder: (_, provider, __){
                                if(provider.likedNews.contains(widget.news.idNews)){
                                  return Icon(Icons.favorite, color: ColorUtils.primary);
                                }
                                return Icon(Icons.favorite_border, color: ColorUtils.primary);
                              },
                            ),
                          ),
                          onPressed: () {
                            if(user != null){
                              if(_isLikedWrapper.result){
                                _presenter.executeUnlike(widget.news.idNews, _isLikedWrapper);
                                return;
                              }
                              _presenter.executeLike(widget.news.idNews, _isLikedWrapper);
                            }
                          },
                        ),
                        SizedBox(width: 5),
                        Consumer<LikeProvider>(
                          builder: (_, provider, __) => Text(provider.getNumberOfLike(widget.news),
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        SizedBox(width: 50),

                        Icon(Icons.share, color: ColorUtils.primary),
                        SizedBox(width: 5),
                        Text("Share this post",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Text("Komentar",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Spacer(),

                      Icon(Icons.chat_bubble_outline, color: ColorUtils.primary),
                      SizedBox(width: 5),
                      Text(widget.news.comments,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: RequestWrapperWidget(
                    requestWrapper: _commentWrapper,
                    placeholder: ListView.builder(
                      itemCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, position) => ShimmerCommentItem(),
                    ),
                    builder: (ctx, response) {
                      var data = response as CommentResponse;
                      return ListView.builder(
                        itemCount: data.data.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, position) => CommentItem(data.data[position]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Tulisan Lainnya",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: RequestWrapperWidget(
                    requestWrapper: _relatedNewsWrapper,
                    placeholder: ListView.builder(
                      itemCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, position) => ShimmerNewsItem(),
                    ),
                    builder: (ctx, response){
                      var data = response as NewsResponse;
                      return ListView.builder(
                        itemCount: data.data.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, position) => NewsItem(data.data[position], _onNewsSelected),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
          isUserLoggedIn ? Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Tulis Komentar...",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _presenter.executeComment(widget.news.idNews, _commentController.text),
                  color: ColorUtils.primary,
                )
              ],
            ),
          ) : SizedBox()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _automaticSlider.cancel();
    super.dispose();
  }
}

