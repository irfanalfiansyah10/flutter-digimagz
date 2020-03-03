import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimagz/custom/view/text/StyledText.dart';
import 'package:digimagz/extension/Size.dart';
import 'package:digimagz/network/response/StoryResponse.dart';
import 'package:digimagz/utilities/ImageUtils.dart';
import 'package:digimagz/utilities/UrlUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoryItem extends StatelessWidget {
  final Story story;
  final Function(Story) onCoverSelected;

  const StoryItem(this.story, this.onCoverSelected, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onCoverSelected(story),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: CachedNetworkImage(
              imageUrl: UrlUtils.URL_IMAGE_STORY + story.imageCoverStory,
              imageBuilder: (ctx, provider) => Container(
                width: adaptiveWidth(context, 150),
                height: adaptiveWidth(context, 150),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (ctx, url) => Shimmer.fromColors(
                child: Container(
                  width: adaptiveWidth(context, 150),
                  height: adaptiveWidth(context, 150),
                  color: Colors.grey[300],
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.white,
              ),
              errorWidget: (_, __, ___) => Container(
                width: adaptiveWidth(context, 150),
                height: adaptiveWidth(context, 150),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageUtils.mqdefault),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: adaptiveWidth(context, 50),
            width: adaptiveWidth(context, 150),
            color: Colors.grey,
            alignment: Alignment.center,
            child: StyledText(story.titleCoverStory,
              size: adaptiveWidth(context, 14),
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class ShimmerStoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: adaptiveWidth(context, 150),
          height: adaptiveWidth(context, 150),
          margin: EdgeInsets.symmetric(horizontal: 5),
          color: Colors.grey[300],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.white);
  }
}
