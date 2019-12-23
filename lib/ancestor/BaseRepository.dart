import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'BaseState.dart';

class BaseRepository{

  BaseState _baseState;

  Dio dio = Dio();

  int _typeRequest = -1;

  BaseRepository(this._baseState, {String baseUrl}){
    dio.interceptors.add(LogInterceptor(responseBody: true));
    if(baseUrl != null) {
      dio.options.baseUrl = baseUrl;
    }else {
      dio.options.baseUrl = "http://digimon.kristomoyo.com/api/";
    }
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.sendTimeout = 60000;
  }

  Future<bool> connectivityChecker() async {
    var connectionStatus = await (Connectivity().checkConnectivity());
    return connectionStatus != ConnectivityResult.none;
  }

  Future<Response<String>> get(String url, Map<String, String> params,
      int typeRequest, {CancelToken cancelToken}) async {
    _typeRequest = typeRequest;

    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try{
      Response<String> response = await dio.get<String>(url, queryParameters: params, cancelToken: cancelToken);

      _baseState.shouldHideLoading(typeRequest);
      return response;
    } on DioError catch(e){
      if(e.type != DioErrorType.CANCEL) {
        _baseState.shouldHideLoading(typeRequest);
        _baseState.onUnknownError(typeRequest, e.message);
      }
    }

    return null;
  }

  Future<Response<String>> post(String url, Map<String, dynamic> params, int typeRequest,
      {CancelToken cancelToken, String contentType = "application/json"}) async {
    _typeRequest = typeRequest;

    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try{
      Response<String> response = await dio.post<String>(url, data: params, options: Options(
          contentType: contentType
      ), cancelToken: cancelToken);

      _baseState.shouldHideLoading(typeRequest);
      return response;
    } on DioError catch(e){
      if(e.type != DioErrorType.CANCEL) {
        _baseState.shouldHideLoading(typeRequest);
        _baseState.onUnknownError(typeRequest, e.message);
      }
    }

    return null;
  }

  Future<Response<String>> delete(String url, Map<String, dynamic> params, int typeRequest,
      {CancelToken cancelToken, String contentType = "application/json"}) async {
    _typeRequest = typeRequest;

    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try{
      Response<String> response = await dio.delete<String>(url, data: params, options: Options(
          contentType: contentType
      ), cancelToken: cancelToken);

      _baseState.shouldHideLoading(typeRequest);
      return response;
    } on DioError catch(e){
      if(e.type != DioErrorType.CANCEL) {
        _baseState.shouldHideLoading(typeRequest);
        _baseState.onUnknownError(typeRequest, e.message);
      }
    }

    return null;
  }

  Future<Response<String>> put(String url, Map<String, dynamic> params, int typeRequest,
      {CancelToken cancelToken, String contentType = "application/json"}) async {
    _typeRequest = typeRequest;

    _baseState.shouldShowLoading(typeRequest);

    var isConnected = await connectivityChecker();
    if(!isConnected){
      _baseState.shouldHideLoading(typeRequest);
      _baseState.onNoConnection(typeRequest);
      return null;
    }

    try{
      Response<String> response = await dio.put<String>(url, data: params, options: Options(
          contentType: contentType
      ), cancelToken: cancelToken);

      var baseResponse = BaseResponse.fromJson(jsonDecode(response.data));
      if(!baseResponse.status){
        throw ResponseException(msg: baseResponse.message);
      }

      _baseState.shouldHideLoading(typeRequest);
      return response;
    } on DioError catch(e){
      if(e.type != DioErrorType.CANCEL) {
        _baseState.shouldHideLoading(typeRequest);
        _baseState.onUnknownError(typeRequest, e.message);
      }
    }

    return null;
  }
}