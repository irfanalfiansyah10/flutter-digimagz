import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/ui/list/news/ListNewsDelegate.dart';
import 'package:flutter/material.dart';

import 'ListNewsPresenter.dart';

class ListNewsArgument{
  final bool isFavorit;
  final String query;

  ListNewsArgument({this.isFavorit = false, this.query = ""});
}

class ListNews extends BaseStatefulWidget {
  final ListNewsArgument argument;

  ListNews(this.argument);

  @override
  _ListNewsState createState() => _ListNewsState();
}

class _ListNewsState extends BaseState<ListNews> implements ListNewsDelegate{
  ListNewsPresenter _presenter;
  RequestWrapper<NewsResponse> _wrapper = RequestWrapper();

  @override
  void initState() {
    super.initState();
    _presenter = ListNewsPresenter(this);
    _presenter.executeGetNews(widget.argument, _wrapper);
  }

  @override
  void shouldHideLoading(int typeRequest) {

  }

  @override
  void shouldShowLoading(int typeRequest) {

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
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            finish();
          },
        ),
      ),
      body: SafeArea(
        child: RequestWrapperWidget(
            requestWrapper: _wrapper,
            placeholder: ListView.builder(
                itemCount: 5,
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, position) => ShimmerNewsItem()),
            builder: (ctx, response){
              var data = response as NewsResponse;
              return ListView.builder(
                  itemCount: data.data.length,
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  itemBuilder: (ctx, position) => NewsItem(data.data[position], onNewsSelected));
            }),
      ),
    );
  }
}

