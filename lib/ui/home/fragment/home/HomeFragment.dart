import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/custom/view/pageIndicator/PageIndicator.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/network/response/StoryResponse.dart';
import 'package:digimagz/ui/home/fragment/home/HomeFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/home/HomeFragmentPresenter.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/StoryAdapter.dart';
import 'package:digimagz/ui/list/news/ListNews.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'adapter/SliderAdapter.dart';

class HomeFragment extends StatefulWidget {
  final state = _HomeFragmentState();

  @override
  _HomeFragmentState createState() => state;
}

class _HomeFragmentState extends BaseState<HomeFragment, HomeFragmentPresenter>
    implements HomeFragmentDelegate{
  RequestWrapper<NewsResponse> _trendingWrapper = RequestWrapper();
  RequestWrapper<NewsResponse> _sliderWrapper = RequestWrapper();
  RequestWrapper<NewsResponse> _newsWrapper = RequestWrapper();
  RequestWrapper<StoryResponse> _storyWrapper = RequestWrapper();

  int _sliderPosition = 0;

  @override
  HomeFragmentPresenter initPresenter() => HomeFragmentPresenter(this);

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void onNoConnection(int typeRequest) {
    if(typeRequest == HomeFragmentPresenter.REQUEST_GET_SLIDER){
      delay(5000, () => presenter.executeGetSlider(_sliderWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS){
      delay(5000, () => presenter.executeGetNews(_newsWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS_TREND){
      delay(5000, () => presenter.executeGetNewsTrending(_trendingWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_STORY){
      delay(5000, () => presenter.executeGetStory(_storyWrapper));
    }else {
      super.onNoConnection(typeRequest);
    }
  }

  @override
  void onRequestTimeOut(int typeRequest) {
    if(typeRequest == HomeFragmentPresenter.REQUEST_GET_SLIDER){
      delay(5000, () => presenter.executeGetSlider(_sliderWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS){
      delay(5000, () => presenter.executeGetNews(_newsWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS_TREND){
      delay(5000, () => presenter.executeGetNewsTrending(_trendingWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_STORY){
      delay(5000, () => presenter.executeGetStory(_storyWrapper));
    }else {
      super.onRequestTimeOut(typeRequest);
    }
  }

  @override
  void onUnknownError(int typeRequest, String msg) {
    if(typeRequest == HomeFragmentPresenter.REQUEST_GET_SLIDER){
      delay(5000, () => presenter.executeGetSlider(_sliderWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS){
      delay(5000, () => presenter.executeGetNews(_newsWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_NEWS_TREND){
      delay(5000, () => presenter.executeGetNewsTrending(_trendingWrapper));
    }else if(typeRequest == HomeFragmentPresenter.REQUEST_GET_STORY){
      delay(5000, () => presenter.executeGetStory(_storyWrapper));
    }else {
      super.onUnknownError(typeRequest, msg);
    }
  }

  @override
  void onNewsSelected(News news) {
    navigateTo(MyApp.ROUTE_DETAIL_NEWS, arguments: news);
  }

  @override
  void onStorySelected(Story story) {
    navigateTo(MyApp.ROUTE_DETAIL_STORY, arguments: story);
  }

  @override
  void onNavigationResume(String from) {
    presenter.executeGetNewsTrending(_trendingWrapper);
    presenter.executeGetNews(_newsWrapper);
  }

  @override
  void initState() {
    super.initState();
    presenter = HomeFragmentPresenter(this);
    presenter.executeGetNewsTrending(_trendingWrapper);
    presenter.executeGetStory(_storyWrapper);
    presenter.executeGetNews(_newsWrapper);
    presenter.executeGetSlider(_sliderWrapper);

    _trendingWrapper.subscribeOnFinishedAndNonNull((r) => Provider.of<LikeProvider>(context).collect(r));
    _newsWrapper.subscribeOnFinishedAndNonNull((r) => Provider.of<LikeProvider>(context).collect(r));
    _sliderWrapper.subscribeOnFinishedAndNonNull((r) => Provider.of<LikeProvider>(context).collect(r));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        presenter.executeGetNewsTrending(_trendingWrapper);
        presenter.executeGetStory(_storyWrapper);
        presenter.executeGetNews(_newsWrapper);
        presenter.executeGetSlider(_sliderWrapper);

        await Future.delayed(Duration(seconds: 2));
      },
      color: Colors.black,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: adaptiveWidth(context, 230),
              child: RequestWrapperWidget(
                requestWrapper: _sliderWrapper,
                placeholder: (_) => ClipRRect(
                  child: Shimmer.fromColors(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                builder: (ctx, response){
                  var data = response as NewsResponse;
                  var slider = <Widget>[];
                  var indicator = <Widget>[];

                  for(int i=0;i<data.data.length;i++){
                    slider.add(SliderItem(data.data[i], onNewsSelected));
                    indicator.add(PageIndicator(_sliderPosition == i));
                  }

                  return Stack(
                    children: <Widget>[
                      PageView(
                        children: slider,
                        onPageChanged: (value){
                          setState(() {
                            _sliderPosition = value;
                          });
                        },
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: indicator,
                          ),
                        ),
                      )
                    ],
                  );
                },),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text("Trending",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 22
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: RequestWrapperWidget(
                  requestWrapper: _trendingWrapper,
                  placeholder: (_) => ListView.builder(
                    itemCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, position) => ShimmerNewsItem(),
                  ),
                  builder: (ctx, response){
                    var data = response as NewsResponse;
                    return ListView.builder(
                      itemCount: data.data.length > 3 ? 3 : data.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, position) => NewsItem(data.data[position], onNewsSelected),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorUtils.primary),
                  ),
                  alignment: Alignment.center,
                  child: Text("Lihat Lainnya",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: ColorUtils.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                onTap: (){
                  navigateTo(MyApp.ROUTE_LIST_NEWS,
                      arguments: ListNewsArgument(isFavorit: true));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text("Cover Story",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 22
                  )),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10),
              height: adaptiveWidth(context, 200),
              child: RequestWrapperWidget(
                requestWrapper: _storyWrapper,
                placeholder: (_) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (ctx, position) => ShimmerStoryItem(),
                ),
                builder: (ctx, response){
                  var data = response as StoryResponse;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.data.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, position) => StoryItem(data.data[position], onStorySelected),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text("Berita",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 22
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: RequestWrapperWidget(
                  requestWrapper: _newsWrapper,
                  placeholder: (_) => ListView.builder(
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
                      itemBuilder: (ctx, position) => NewsItem(data.data[position], onNewsSelected),
                    );
                  }),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
