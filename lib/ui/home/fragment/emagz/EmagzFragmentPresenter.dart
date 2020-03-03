import 'package:digimagz/ancestor/BasePresenter.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:mcnmr_request_wrapper/RequestWrapper.dart';

class EmagzFragmentPresenter extends BasePresenter{
  static const REQUEST_GET_EMAGZ = 0;
  static const REQUEST_DOWNLOAD_EBOOK = 1;

  EmagzFragmentPresenter(BaseState state) : super(state);

  void executeGetEmagz(RequestWrapper<EmagzResponse> wrapper) async {
    wrapper.doRequest();

    var response = await repository.getEmagz(REQUEST_GET_EMAGZ);
    if(response != null){
      wrapper.finishRequest(response);
    }
  }
}