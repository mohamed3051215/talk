import 'package:chat_app/core/constants/colors.dart';
// import 'package:chat_app/core/constants/fake_data.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general widgets/custom_text.dart';

class TextMessage extends StatelessWidget {
   TextMessage({Key? key, required this.message, required this.time, required this.chatId})
      : super(key: key);
  final Message message;
  final String time , chatId;

  final HomeScreenController _homeScreenController = Get.find<HomeScreenController>();
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
        ],
      ),
    );
  }
}
