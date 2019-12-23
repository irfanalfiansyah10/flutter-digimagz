import 'package:mcnmr_common_ext/NonNullChecker.dart';
import 'package:digimagz/network/response/BaseResponse.dart';

class CommentResponse extends BaseResponse{
  List<Comment> data;

  CommentResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    data = List();
    if(json["data"] != null){
      json["data"].forEach((it) => data.add(Comment.fromJson(it)));
    }
  }
}

class Comment {
  String idNews;
  String email;
  String commentText;
  String isApproved;
  String dateComment;
  String userName;
  String profilepicUrl;

  Comment.fromJson(Map<String, dynamic> json){
    idNews = obtainValue(json["ID_NEWS"], "");
    email = obtainValue(json["EMAIL"], "");
    commentText = obtainValue(json["COMMENT_TEXT"], "");
    isApproved = obtainValue(json["IS_APPROVED"], "");
    dateComment = obtainValue(json["DATE_COMMENT"], "");
    userName = obtainValue(json["USER_NAME"], "");
    profilepicUrl = obtainValue(json["PROFILEPIC_URL"], "");
  }
}