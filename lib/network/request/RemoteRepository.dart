import 'dart:convert';

import 'package:digimagz/ancestor/BaseRepository.dart';
import 'package:digimagz/ancestor/BaseState.dart';
import 'package:digimagz/network/response/BaseResponse.dart';
import 'package:digimagz/network/response/CommentResponse.dart';
import 'package:digimagz/network/response/EmagzResponse.dart';
import 'package:digimagz/network/response/NewsCoverStoryResponse.dart';
import 'package:digimagz/network/response/NewsResponse.dart';
import 'package:digimagz/network/response/StoryResponse.dart';
import 'package:digimagz/network/response/UserResponse.dart';
import 'package:digimagz/network/response/YoutubeResponse.dart';
import 'package:digimagz/network/response/TokenResponse.dart';
import 'package:dio/dio.dart';

class Repository extends BaseRepository {
  Repository(BaseState baseState) : super(baseState);

  Future<NewsResponse> getNews(int typeRequest, {CancelToken cancelToken}) async {
    var response = await get("dummy/index_get", null, typeRequest, cancelToken: cancelToken);

    if(response != null){
      return NewsResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<NewsResponse> getNewsSearch(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("dummy/index_get", params, typeRequest);

    if(response != null){
      return NewsResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<NewsResponse> getNewsTrending(int typeRequest, Map<String, dynamic> params,
      {CancelToken cancelToken}) async {
    var response = await get("dummy/index_get", params, typeRequest, cancelToken: cancelToken);

    if(response != null){
      return NewsResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<NewsResponse> getNewsRelated(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("related/index_get", params, typeRequest);

    if(response != null){
      return NewsResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<NewsResponse> getSlider(int typeRequest) async {
    var response = await get("slider/index_get", null, typeRequest);

    if(response != null){
      return NewsResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<StoryResponse> getStory(int typeRequest) async {
    var response = await get("story/index_get", null, typeRequest);

    if(response != null){
      return StoryResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<NewsCoverStoryResponse> getNewsFromStory(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("newscover/index_get", params, typeRequest);

    if(response != null){
      return NewsCoverStoryResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<CommentResponse> getComment(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("comments/index_get", params, typeRequest);

    if(response != null){
      return CommentResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<UserResponse> getUser(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("user/index_get", params, typeRequest);

    if(response != null){
      print("API Get User : $response");
      return UserResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> getLikes(int typeRequest, Map<String, dynamic> params) async {
    var response = await get("likes/index_get", params, typeRequest, throwOnResponseError: false);

    if(response != null){
      return BaseResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<YoutubeResponse> getVideo(int typeRequest) async {
    var response = await get("video/index_get", null, typeRequest);

    if(response != null){
      return YoutubeResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<EmagzResponse> getEmagz(int typeRequest) async {
    var response = await get("emagz/index_get", null, typeRequest);

    if(response != null){
      return EmagzResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<TokenResponse> postToken(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("firebase_notif/register", params, typeRequest);

    if(response != null){
      return TokenResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<Comment> postComment(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("comments/index_post", params, typeRequest);

    if(response != null){
      return Comment.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> postLike(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("likes/index_post", params, typeRequest, throwOnResponseError: false);

    if(response != null){
      return BaseResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> postView(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("dummy/click", params, typeRequest, throwOnResponseError: false);

    if(response != null){
      return BaseResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> postShare(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("dummy/share", params, typeRequest, throwOnResponseError: false);

    if(response != null){
      return BaseResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<User> postUser(int typeRequest, Map<String, dynamic> params) async {
    var response = await post("user/index_post", params, typeRequest);

    if(response != null){
      print("API Post User : $response");
      return User.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> deleteLike(int typeRequest, Map<String, dynamic> params) async {
    var response = await delete("likes/index_delete", params, typeRequest,
        throwOnResponseError: false,
        contentType: "application/x-www-form-urlencoded");

    if(response != null){
      return BaseResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<UserResponse> putUser(int typeRequest, Map<String, dynamic> params) async {
    var response = await put("user/index_put", params, typeRequest,
        contentType: "application/x-www-form-urlencoded");

    if(response != null){
      return UserResponse.fromJson(jsonDecode(response.data));
    }

    return null;
  }

  Future<BaseResponse> changeAvatar(int typeRequest, Map<String, dynamic> params) async {
    var response = await formData("user/avatar", params, typeRequest, throwOnResponseError: false);

    if(response != null){
      print(response);
    }

    return null;
  }
}
