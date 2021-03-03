import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:dio/dio.dart';
import 'BaseState.dart';

class BaseRepository{

  static const GET = 0;
  static const POST = 1;
  static const PUT = 2;
  static const DELETE = 3;

  BaseState _baseState;

  Dio dio = Dio();

  BaseRepository(this._baseState, {String baseUrl}){
    dio.interceptors.add(LogInterceptor(responseBody: false));
    if(baseUrl != null) {
      dio.options.baseUrl = baseUrl;
    }else {
      dio.options.baseUrl = UrlUtils.URL+"api/";
    }
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.sendTimeout = 60000;
  }

  Future<bool> connectivityChecker() async {
    var connectionStatus = await (Connectivity().checkConnectivity());
    return connectionStatus != ConnectivityResult.none;
  }

  Future<Response<String>> get(String url,
      Map<String, String> params,
      int typeRequest,
      {
        CancelToken cancelToken,
        String contentType = "application/json",
        bool throwOnResponseError = true
      }) {
    return _execute(GET, url, params, typeRequest,
        cancelToken: cancelToken, contentType: contentType,
        throwOnResponseError: throwOnResponseError);
  }

  Future<Response<String>> post(String url,
      Map<String, dynamic> params,
      int typeRequest,
      {
        CancelToken cancelToken,
        String contentType = "application/json",
        bool throwOnResponseError = true
      }){
    return _execute(POST, url, params, typeRequest,
        cancelToken: cancelToken, contentType: contentType,
        throwOnResponseError: throwOnResponseError);
  }

  Future<Response<String>> delete(String url,
      Map<String, dynamic> params,
      int typeRequest,
      {
        CancelToken cancelToken,
        String contentType = "application/json",
        bool throwOnResponseError = true
      }) {
    return _execute(DELETE, url, params, typeRequest,
        cancelToken: cancelToken, contentType: contentType,
        throwOnResponseError: throwOnResponseError);
  }

  Future<Response<String>> put(String url,
      Map<String, dynamic> params,
      int typeRequest,
      {
        CancelToken cancelToken,
        String contentType = "application/json",
        bool throwOnResponseError = true
      }) {
    return _execute(PUT, url, params, typeRequest,
        cancelToken: cancelToken,
        contentType: contentType,
        throwOnResponseError: throwOnResponseError
    );
  }

  Future<Response<String>> formData(String url,
      Map<String, dynamic> params,
      int typeRequest,
      {
        CancelToken cancelToken,
        String contentType = "multipart/form-data",
        bool throwOnResponseError = true
      }){
    return _execute(POST, url, params, typeRequest,
        cancelToken: cancelToken,
        contentType: contentType,
        isFormData: true,
        throwOnResponseError: throwOnResponseError
    );
  }

  void download(int typeRequest, String urlPath, String savePath, ProgressCallback callback,
      { Function(Response) completion, CancelToken cancelToken}) async {
    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try {
      var result = await dio.download(
          urlPath,
          savePath,
          onReceiveProgress: callback,
          options: Options(
              receiveTimeout: 24 * 60 * 60 * 1000,
              sendTimeout: 24 * 60 * 60 * 1000
          ),
          deleteOnError: true,
          cancelToken: cancelToken
      );

      _baseState.shouldHideLoading(typeRequest);

      if (completion != null) {
        completion(result);
      }
    } on DioError catch(e){
      if(e.type == DioErrorType.CANCEL) {
        _baseState.shouldHideLoading(typeRequest);
      }else if(e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT){
        _baseState.shouldHideLoading(typeRequest);
        _baseState.onRequestTimeOut(typeRequest);
      }else {
        if(e.message.contains("SocketException")){
          _baseState.shouldHideLoading(typeRequest);
          _baseState.onNoConnection(typeRequest);
        }else {
          _baseState.shouldHideLoading(typeRequest);
          _baseState.onUnknownError(typeRequest, e.message);
        }
      }
    }
  }

  Future<Response<String>> _execute(int method, String url, Map<String, dynamic> params,
      int typeRequest, { CancelToken cancelToken,
        String contentType = "application/json",
        bool isFormData = false,
        bool throwOnResponseError = true
      }) async {
    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try{
      Response<String> response;

      if(method == GET){
        response = await dio.get<String>(url, queryParameters: params, options: Options(
            contentType: contentType
        ), cancelToken: cancelToken);
      }else if(method == POST){
        if(isFormData){
          var formData = FormData.fromMap(params);
          response = await dio.post<String>(url, data: formData, options: Options(
            contentType: contentType,
          ), cancelToken: cancelToken);
        }else {
          response = await dio.post<String>(url, data: params, options: Options(
            contentType: contentType,
          ), cancelToken: cancelToken);
        }
      }else if(method == PUT){
        response = await dio.put<String>(url, data: params, options: Options(
            contentType: contentType
        ), cancelToken: cancelToken);
      }else if(method == DELETE){
        response = await dio.delete<String>(url, data: params, options: Options(
            contentType: contentType
        ), cancelToken: cancelToken);
      }else {
        return null;
      }

      if(throwOnResponseError) {
        var baseResponse = BaseResponse.fromJson(jsonDecode(response.data));
        if (!baseResponse.status) {
          throw ResponseException(msg: baseResponse.message);
        }
      }

      _baseState.shouldHideLoading(typeRequest);
      return response;
    } on DioError catch(e){
      print("Error ${e.response.data}");
      if(throwOnResponseError) {
        if (e.type != DioErrorType.CANCEL) {
          if (e.message.contains("SocketException")) {
            _baseState.shouldHideLoading(typeRequest);
            _baseState.onNoConnection(typeRequest);
          } else if (e.message.contains("504")) {
            _baseState.shouldHideLoading(typeRequest);
            _baseState.onRequestTimeOut(typeRequest);
          } else {
            _baseState.shouldHideLoading(typeRequest);
            _baseState.onUnknownError(typeRequest, e.message);
          }
        }
      }
    } on ResponseException catch(e){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onResponseError(typeRequest, e);
    }

    return null;
  }
}