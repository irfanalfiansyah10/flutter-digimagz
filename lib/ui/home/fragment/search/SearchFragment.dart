import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/provider/LikeProvider.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/main.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/ui/home/fragment/home/adapter/news/NewsAdapter.dart';
import 'package:digimagz/ui/home/fragment/search/SearchFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/search/SearchFragmentPresenter.dart';
import 'package:digimagz/ui/list/news/ListNews.dart';
import 'package:digimagz/utilities/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFragment extends StatefulWidget {
  final state = _SearchFragmentState();

  @override
  _SearchFragmentState createState() => state;

  void visit(){
    state.visit();
  }

}

class _SearchFragmentState extends BaseState<SearchFragment, SearchFragmentPresenter>
    implements SearchFragmentDelegate{
  RequestWrapper<NewsResponse> _wrapper = RequestWrapper();

  TextEditingController _searchController = TextEditingController();

  bool isFirstVisit = true;

  @override
  SearchFragmentPresenter initPresenter() => SearchFragmentPresenter(this);

  @override
  void initState() {
    super.initState();
    _wrapper.subscribeOnFinishedAndNonNull((r) => Provider.of<LikeProvider>(context).collect(r));
  }

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void onRequestTimeOut(int typeRequest) => delay(5000, () => presenter.executeGetNews(_wrapper));

  @override
  void onNoConnection(int typeRequest) => delay(5000, () => presenter.executeGetNews(_wrapper));

  @override
  void onNewsSelected(News news) {
    navigateTo(MyApp.ROUTE_DETAIL_NEWS, arguments: news);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Flexible(
                child: Stack(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      textInputAction: TextInputAction.search,
                      controller: _searchController,
                      onFieldSubmitted: (value){
                        navigateTo(MyApp.ROUTE_LIST_NEWS, arguments: ListNewsArgument(query: value));
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 35),
                        labelText: "Kata Kunci",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      right: 5,
                      child: Icon(Icons.search, color: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10),
              MaterialButton(
                color: ColorUtils.primary,
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                onPressed: (){
                  navigateTo(MyApp.ROUTE_LIST_NEWS,
                      arguments: ListNewsArgument(query: _searchController.text));
                },
                child: Text("Search",
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),),
              )
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                presenter.executeGetNews(_wrapper);
                await Future.delayed(Duration(seconds: 2));
              },
              color: Colors.black,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text("Rekomendasi",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 22
                          )),
                    ),
                    RequestWrapperWidget(
                      requestWrapper: _wrapper,
                      placeholder: ListView.builder(
                        itemCount: 5,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, position) => ShimmerNewsItem(),
                      ),
                      builder: (ctx, response){
                        var data = response as NewsResponse;

                        return ListView.builder(
                          itemCount: data.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, position) => NewsItem(data.data[position], onNewsSelected),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void visit(){
    if(isFirstVisit) {
      presenter.executeGetNews(_wrapper);
      isFirstVisit = false;
    }
  }
}
