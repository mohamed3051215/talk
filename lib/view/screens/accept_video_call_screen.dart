import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/colors.dart';
import '../../core/controllers/chat_controller.dart';
import '../../core/models/user.dart';
import '../../core/service/firestore_service.dart';
import '../widgets/general widgets/circle_button_for_call.dart';
import '../widgets/general widgets/custom_text.dart';
import '../widgets/general widgets/image_filter.dart';
import '../widgets/general widgets/logo.dart';
import 'home_screen.dart';
import 'video_call_screen.dart';

class AcceptVideoCallScreen extends StatefulWidget {
  final UserModel userModel;
  final String channelName, chatId, token;
  final bool isBackground;
  const AcceptVideoCallScreen(
      {Key? key,
      required this.userModel,
      required this.channelName,
      required this.chatId,
      required this.token,
      required this.isBackground})
      : super(key: key);

  @override
  State<AcceptVideoCallScreen> createState() => _AcceptVideoCallScreenState();
}

class _AcceptVideoCallScreenState extends State<AcceptVideoCallScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    super.initState();
    player.open(
      Audio("assets/audios/ringtone1.wav"),
      autoStart: true,
    );
    try {
      Get.find<ChatController>().isInCall = true;
    } catch (e) {
      print("Error : " + e.toString());
    }

    Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        player.stop();
        timer.cancel();
        Get.off(HomeScreen());
      }
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                '${widget.userModel.username}\nIs Asking For Video Call ',
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
                      player.stop();
                      Get.offAll(() => HomeScreen());

                      FirestoreService.rejectCall(chatId: widget.chatId);
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
                      Get.off(VideoCallScreen(
                        channelName: widget.channelName,
                        token: widget.token,
                        chatId: widget.chatId,
                        userModel: widget.userModel,
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
