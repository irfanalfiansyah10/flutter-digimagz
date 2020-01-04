import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/ui/list/news/ListNewsDelegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListNewsPresenter.dart';

class ListNewsArgument{
  final bool isFavorit;
  final String query;

  ListNewsArgument({this.isFavorit = false, this.query = ""});
}

class ListNews extends StatefulWidget {
  final ListNewsArgument argument;

  ListNews(this.argument);

  @override
  _ListNewsState createState() => _ListNewsState();
}

class _ListNewsState extends BaseState<ListNews, ListNewsPresenter> implements ListNewsDelegate{
  RequestWrapper<NewsResponse> _wrapper = RequestWrapper();

  @override
  ListNewsPresenter initPresenter() => ListNewsPresenter(this);

  @override
  void initState() {
    super.initState();
    presenter.executeGetNews(widget.argument, _wrapper);

    _wrapper.subscribeOnFinishedAndNonNull((r) => Provider.of<LikeProvider>(context).collect(r));
  }

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void onRequestTimeOut(int typeRequest) => delay(5000, () => presenter.executeGetNews(widget.argument, _wrapper));

  @override
  void onNoConnection(int typeRequest) => delay(5000, () => presenter.executeGetNews(widget.argument, _wrapper));

  @override
  void onUnknownError(int typeRequest, String msg) =>
      delay(5000, () => presenter.executeGetNews(widget.argument, _wrapper));

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
          },
        ),
      ),
      body: RequestWrapperWidget<NewsResponse>(
        requestWrapper: _wrapper,
        placeholder: ListView.builder(
          itemCount: 5,
          padding: EdgeInsets.all(15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, position) => ShimmerNewsItem(),
        ),
        builder: (ctx, response) => RefreshIndicator(
          onRefresh: () async {
            presenter.executeGetNews(widget.argument, _wrapper);
            await Future.delayed(Duration(seconds: 2));
          },
          color: Colors.black,
          backgroundColor: Colors.white,
          child: ListView.builder(
            itemCount: response.data.length,
            padding: EdgeInsets.all(15),
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, position) => NewsItem(response.data[position], onNewsSelected),
          ),
        ),
      ),
    );
  }
}

