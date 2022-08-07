import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/constants/colors.dart';

import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/helpers/random_tag.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:chat_app/view/screens/view_image_screen.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageMessage extends StatelessWidget {
  ImageMessage({Key? key, required this.message, required this.time, required this.chatId})
      : super(key: key);
  final Message message;
  final String time;
  final String chatId;
  final String tag = getRandomString(5);
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Align(
              alignment: message.from == _homeScreenController.userModel!.id
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(time, fontFamily: rRegular, fontSize: 15))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: message.from == _homeScreenController.userModel!.id
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                  decoration: BoxDecoration(
                      color: message.from == _homeScreenController.userModel!.id
                          ? lightBlue
                          : lightPurple,
                      borderRadius: BorderRadius.circular(17)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        message.text,
                        color: Colors.black,
                        fontFamily: rRegular,
                        fontSize: 15,
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Align(
              alignment: message.from == _homeScreenController.userModel!.id
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Get.to(ViewImageScreen(link: message.link!, tag: tag));
                },
                child: Hero(
                  tag: tag,
                  child: Container(
                    width: Get.width / 1.5,
                    height: 300,
                    color: Colors.black.withOpacity(.5),
                    child: CachedNetworkImage(
                      imageUrl: message.link!,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
