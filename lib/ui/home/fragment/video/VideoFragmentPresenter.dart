import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';
import 'package:digimagz/network/response/YoutubeResponse.dart';

class VideoFragmentPresenter extends BasePresenter {
  static const REQUEST_GET_YOUTUBE_CHANNEL = 0;

  VideoFragmentPresenter(BaseState state) : super(state);

  void executeGetVideo(RequestWrapper<YoutubeResponse> wrapper) async {
    wrapper.doRequest();
    wrapper.finishRequestIfNotNull(await repository.getVideo(REQUEST_GET_YOUTUBE_CHANNEL));
  }

}