import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/CommentResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem(this.comment, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: comment.profilepicUrl,
              imageBuilder: (ctx, provider) => Container(
                width: adaptiveWidth(context, 36),
                height: adaptiveWidth(context, 36),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.contain,
                  ),
                  shape: BoxShape.circle
                ),
              ),
              errorWidget: (ctx, a, b) => Container(
                child: Icon(Icons.person, color: Colors.grey),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
              ),
              placeholder: (ctx, url) => Shimmer.fromColors(
                child: Container(
                  width: adaptiveWidth(context, 36),
                  height: adaptiveHeight(context, 36),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle
                  ),
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ),
            ),
            SizedBox(width: adaptiveWidth(context, 15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(comment.email,
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: adaptiveWidth(context, 8)),
                  Text(comment.commentText,
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: adaptiveWidth(context, 8)),
                  Text(comment.dateComment,
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerCommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(adaptiveWidth(context, 10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Shimmer.fromColors(
              child: Container(
                width: adaptiveWidth(context, 36),
                height: adaptiveHeight(context, 36),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle
                ),
              ),
              baseColor: Colors.grey[300],
              highlightColor: Colors.white,
            ),
            SizedBox(width: adaptiveWidth(context, 15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 150),
                      height: adaptiveHeight(context, 15),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  SizedBox(height: adaptiveWidth(context, 8)),
                  Shimmer.fromColors(
                    child: Container(
                      width: double.infinity,
                      height: adaptiveHeight(context, 45),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                  SizedBox(height: adaptiveWidth(context, 8)),
                  Shimmer.fromColors(
                    child: Container(
                      width: adaptiveWidth(context, 50),
                      height: adaptiveHeight(context, 15),
                      color: Colors.grey[300],
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

