import 'package:chat_app/core/constants/colors.dart';

import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:chat_app/view/screens/view_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../general widgets/custom_text.dart';

class VideoMessage extends StatefulWidget {
  const VideoMessage({Key? key, required this.message, required this.time, required this.chatId})
      : super(key: key);
  final Message message;

  final String time , chatId;
  @override
  _VideoMessageState createState() => _VideoMessageState(message, time);
}

class _VideoMessageState extends State<VideoMessage>
    with SingleTickerProviderStateMixin {
  _VideoMessageState(this.message, this.time);
  final Message message;
  final String time;
  late VideoPlayerController _controller;
  bool loading = true;
  bool playing = false;
  late AnimationController _animationController;
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller = VideoPlayerController.network(message.link!)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          loading = false;
        });
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animationController.dispose();
  }

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
                      color:
                          message.from == _homeScreenController.userModel!.id ? lightBlue : lightPurple,
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
          Align(
            alignment: message.from == _homeScreenController.userModel!.id
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Container(
                  height: 300,
                  width: Get.width / 1.5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.to(ViewViedeoScreen(link: message.link!));
                          },
                          child: VideoPlayer(_controller)),
                      !loading
                          ? Positioned(
                              child: InkWell(
                              onTap: () {
                                !playing
                                    ? _animationController.forward()
                                    : _animationController.reverse();
                                !playing
                                    ? _controller.play()
                                    : _controller.pause();
                                playing = !playing;
                              },
                              child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _animationController,
                                  size: 50,
                                  color: lightPurple),
                            ))
                          : CircularProgressIndicator(
                              color: lightPurple,
                            )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
