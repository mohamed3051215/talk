import 'dart:ui';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/view/screens/voice_call_screen.dart';
import 'package:chat_app/view/widgets/general%20widgets/circle_button_for_call.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/view/widgets/general widgets/image_filter.dart';
import '../../core/constants/colors.dart';
import '../../core/models/user.dart';
import '../widgets/general widgets/logo.dart';

class AcceptAudioCallScreen extends StatelessWidget {
  final UserModel userModel;
  const AcceptAudioCallScreen({Key? key, required this.userModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Align(alignment: Alignment.topCenter, child: Logo()),
            ImageFilter(
              hue: 0,
              brightness: -0.8,
              saturation: 0.9,
              child: Container(
                width: Get.width,
                height: Get.height,
                child: CachedNetworkImage(
                  imageUrl: userModel.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment(0, -.5),
                child: CustomText(
                    '${userModel.username}\nIs Asking For Audio Call ',
                    color: lightPurple,
                    fontSize: 35,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w200)),
            Align(
                alignment: Alignment(0, .7),
                child: Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleButtonForCall(
                        icon: Icons.phone,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        buttonColor: Colors.red,
                        size: 80,
                        iconColor: lightPurple,
                        iconSize: 40,
                      ),
                      CircleButtonForCall(
                        icon: Icons.phone,
                        onPressed: () {
                          Get.to(VoiceCallScreen());
                        },
                        buttonColor: Colors.green,
                        size: 80,
                        iconColor: lightPurple,
                        iconSize: 40,
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
