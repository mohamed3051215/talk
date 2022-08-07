import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImageScreen extends StatelessWidget {
  const ViewImageScreen({Key? key, required this.link, required this.tag})
      : super(key: key);
  final String link, tag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: lightPurple,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Hero(
        tag: tag,
        child: Center(
            child: InteractiveViewer(
          onInteractionStart: (ScaleStartDetails d) {},
          onInteractionUpdate: (ScaleUpdateDetails d) {},
          child: CachedNetworkImage(
            imageUrl: link,
            // fit: BoxFit.cover,
            // width: Get.width,
            height: Get.height,
          ),
        )),
      ),
    );
  }
}
