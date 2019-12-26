import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_common_ext/FutureDelayed.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:mcnmr_request_wrapper/RequestWrapperWidget.dart';
import 'package:digimagz/network/response/YoutubeResponse.dart';
import 'package:digimagz/ui/home/fragment/video/VideoFragmentDelegate.dart';
import 'package:digimagz/ui/home/fragment/video/VideoFragmentPresenter.dart';
import 'package:digimagz/ui/home/fragment/video/adapter/VideoAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoFragment extends StatefulWidget {

  final state = _VideoFragmentState();

  @override
  _VideoFragmentState createState() => state;

  void visit(){
    state.visit();
  }
}

class _VideoFragmentState extends BaseState<VideoFragment>
    implements VideoFragmentDelegate{
  VideoFragmentPresenter _presenter;
  RequestWrapper<YoutubeResponse> _youtubeWrapper = RequestWrapper();

  bool isFirstVisit = true;

  @override
  void initState() {
    super.initState();
    _presenter = VideoFragmentPresenter(this);
  }

  @override
  void shouldHideLoading(int typeRequest) {}

  @override
  void shouldShowLoading(int typeRequest) {}

  @override
  void onNoConnection(int typeRequest) => delay(5000, () => _presenter.executeGetVideo(_youtubeWrapper));

  @override
  void onRequestTimeOut(int typeRequest) => delay(5000, () => _presenter.executeGetVideo(_youtubeWrapper));

  @override
  void onPlayVideo(YoutubeVideo video) {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyBXmYa9XW8pUIVu3_jfZRH1GuloT8d1tgo",
      videoUrl: "https://www.youtube.com/watch?v=${video.idVideo}",
      autoPlay: true,
      fullScreen: true,
    );
  }

  @override
  void onRedirectYoutube(YoutubeVideo video) async {
    var url = "http://www.youtube.com/watch?v=${video.idVideo}";

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Tidak dapat membuka aplikasi Youtube';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _presenter.executeGetVideo(_youtubeWrapper);
      },
      color: Colors.black,
      backgroundColor: Colors.white,
      child: RequestWrapperWidget(
        requestWrapper: _youtubeWrapper,
        placeholder: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (ctx, position) => ShimmerVideoItem(),
        ),
        builder: (ctx, response) {
          var data = response as YoutubeResponse;
          return ListView.builder(
            itemCount: data.data.length,
            shrinkWrap: true,
            itemBuilder: (ctx, position) => VideoItem(data.data[position], this),
          );
        },
      ),
    );
  }

  void visit(){
    if(isFirstVisit) {
      _presenter.executeGetVideo(_youtubeWrapper);

      isFirstVisit = false;
    }
  }
}
