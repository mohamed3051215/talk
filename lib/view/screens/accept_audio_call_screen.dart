import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/view/screens/home_screen.dart';
import 'package:chat_app/view/screens/video_call_screen.dart';
import 'package:chat_app/view/screens/voice_call_screen.dart';
import 'package:chat_app/view/widgets/general%20widgets/circle_button_for_call.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chat_app/view/widgets/general widgets/image_filter.dart';
import '../../core/constants/colors.dart';
import '../../core/controllers/chat_controller.dart';
import '../../core/models/user.dart';
import '../widgets/general widgets/logo.dart';
import "package:assets_audio_player/assets_audio_player.dart";

class AcceptAudioCallScreen extends StatefulWidget {
  final UserModel userModel;
  final String channelName, chatId, token;
  final bool isBackground;
  const AcceptAudioCallScreen(
      {Key? key,
      required this.userModel,
      required this.channelName,
      required this.chatId,
      required this.token,
      required this.isBackground})
      : super(key: key);

  @override
  State<AcceptAudioCallScreen> createState() => _AcceptAudioCallScreenState();
}

class _AcceptAudioCallScreenState extends State<AcceptAudioCallScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  @override
  void initState() {
    super.initState();
    player.open(Audio("assets/audios/ringtone1.wav"),
        autoStart: true, loopMode: LoopMode.single);
    try {
      Get.find<ChatController>().isInCall = true;
    } catch (e) {
      print("Error : " + e.toString());
    }

    Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        player.stop();
        timer.cancel();
        Get.off(() => HomeScreen());
      }
      timer.cancel();
    });
  }

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
                  imageUrl: widget.userModel.image,
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
                    '${widget.userModel.username}\nIs Asking For Audio Call ',
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
                          if (widget.isBackground) {
                            SystemNavigator.pop();
                            SystemNavigator.pop();
                            SystemNavigator.pop();
                            player.stop();
                            return;
                          }

                          Get.offAll(() => HomeScreen());
                          player.stop();
                        },
                        buttonColor: Colors.red,
                        size: 80,
                        iconColor: lightPurple,
                        iconSize: 40,
                      ),
                      CircleButtonForCall(
                        icon: Icons.phone,
                        onPressed: () {
                          player.stop();
                          Get.off(VoiceCallScreen(
                            token2: widget.token,
                            userModel: widget.userModel,
                            channelName2: widget.channelName,
                            chatId: widget.chatId,
                          ));
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
