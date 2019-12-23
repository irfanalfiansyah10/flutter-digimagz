import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/YoutubeResponse.dart';
import 'package:digimagz/ui/home/fragment/video/VideoFragmentDelegate.dart';

class VideoFragmentPresenter extends BasePresenter {
  static const REQUEST_GET_YOUTUBE_CHANNEL = 0;

  final VideoFragmentDelegate _delegate;

  VideoFragmentPresenter(BaseState<BaseStatefulWidget> state, this._delegate) : super(state);

  void executeGetVideo(RequestWrapper<YoutubeResponse> wrapper) async {
    wrapper.doRequest();
    wrapper.finishRequestIfNotNull(await repository.getVideo(REQUEST_GET_YOUTUBE_CHANNEL));
  }

}