import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/controllers/home_screen_controller.dart';
import '../../../core/models/message.dart';
import '../../../core/service/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general widgets/custom_text.dart';

class AudioMessage extends StatefulWidget {
  const AudioMessage(
      {Key? key,
      required this.time,
      required this.message,
      required this.chatId})
      : super(key: key);
  final String time;
  final Message message;
  final String chatId;
  @override
  _AudioMessageState createState() => _AudioMessageState(message, time);
}

class _AudioMessageState extends State<AudioMessage>
    with SingleTickerProviderStateMixin {
  _AudioMessageState(this.message, this.time);
  final Message message;
  final String time;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? linkStream;
  bool playing = false;
  final HomeScreenController _homeScreenController =
      Get.find<HomeScreenController>();
  LocalStorageService _service = LocalStorageService();
  AudioPlayer audioPlayer = AudioPlayer();

  bool loading = true;
  String? link;
  late AnimationController _animationController;
  int max = 10;
  Duration playerValue = Duration(seconds: 0);
  String audioTime = "0:00";
  initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _initAudioPlayer();
  }

  String _setStringTime() {
    int mins;
    int seconds;
    int totalSeconds = max;
    totalSeconds = max - playerValue.inSeconds;
    seconds = totalSeconds % 60;
    mins = totalSeconds ~/ 60;

    if (totalSeconds / 60 > mins) {
      return "$mins:${seconds.toString().length == 1 ? '0$seconds' : seconds}";
    } else {
      mins = mins - 1;
      return "$mins:${seconds.toString().length == 1 ? '0$seconds' : seconds}";
    }
  }

  _initAudioPlayer() async {
    // audioPlayer.
    bool exists = await _service.isAudioFileExists(message.id, widget.chatId);

    if (message.link == null && !exists) {
      String filename;
      printInfo(info: "link = null");
      linkStream = FirebaseFirestore.instance
          .collection("chat")
          .doc(widget.chatId)
          .collection("messages")
          .doc(message.id)
          .snapshots()
          .listen((event) async {
        printInfo(info: "link is ${event['link']}");
        if (event["link"] != null) {
          await _service.storeAudio(
              id: message.id, link: event["link"], chatId: widget.chatId);
          filename =
              (await _service.getAudio(id: message.id, chatId: widget.chatId))!;
          printInfo(info: "filename is $filename");
          await audioPlayer.setUrl(filename, isLocal: true);

          audioPlayer.onDurationChanged.listen((Duration duration) {
            setState(() {
              max = duration.inSeconds;
              print("audioTime set" + message.id);
              audioTime = _setStringTime();
            });
          });

          audioPlayer.onAudioPositionChanged.listen((event) {
            setState(() {
              playerValue = event;
              audioTime = _setStringTime();
            });
          });
          audioPlayer.onPlayerStateChanged.listen((event) {
            switch (event) {
              case PlayerState.COMPLETED:
                setState(() {
                  playing = false;
                  playerValue = Duration(seconds: 0);
                  audioTime =
                      "${max ~/ 60}:${max % 60.toString().length == 1 ? '0${max % 60}' : '${max % 60}'}";
                });

                _animationController.reverse();
                break;
              default:
            }
          });
          printInfo(info: "Stop loading");
          loading = false;
          linkStream?.cancel();
        }
      });
    } else {
      printInfo(info: "link is not = null");

      String filename;
      if (exists) {
        filename =
            (await _service.getAudio(id: message.id, chatId: widget.chatId))!;
        printInfo(info: "filename is $filename");
      } else {
        filename = (await _service.storeAudio(
            id: message.id, link: message.link!, chatId: widget.chatId))!;
      }
      await audioPlayer.setUrl(filename, isLocal: true);

      audioPlayer.onDurationChanged.listen((Duration duration) {
        print("audioTime set");
        setState(() {
          max = duration.inSeconds;
          audioTime = _setStringTime();
        });
      });

      audioPlayer.onAudioPositionChanged.listen((event) {
        print("audioTime set");
        setState(() {
          playerValue = event;
          audioTime = _setStringTime();
        });
      });
      audioPlayer.onPlayerStateChanged.listen((event) {
        switch (event) {
          case PlayerState.COMPLETED:
            setState(() {
              playing = false;
              playerValue = Duration(seconds: 0);
              audioTime =
                  "${max ~/ 60}:${max % 60.toString().length == 1 ? '0${max % 60}' : '${max % 60}'}";
            });
            _animationController.reverse();
            break;
          default:
        }
      });

      loading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    audioPlayer.dispose();
    linkStream?.cancel();
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
          message.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment:
                        message.from == _homeScreenController.userModel!.id
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Container(
                        decoration: BoxDecoration(
                            color: message.from ==
                                    _homeScreenController.userModel!.id
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
                )
              : SizedBox(),
          Align(
              alignment: message.from == _homeScreenController.userModel!.id
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    Container(
                        width: Get.width / 1.5,
                        height: 60,
                        decoration: BoxDecoration(
                            color: message.from ==
                                    _homeScreenController.userModel!.id
                                ? lightBlue
                                : lightPurple,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            loading
                                ? CircularProgressIndicator(
                                    color: bluePurple,
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (playing) {
                                        setState(() {
                                          playing = false;
                                        });
                                        audioPlayer.pause();
                                        _animationController.reverse();
                                      } else {
                                        setState(() {
                                          playing = true;
                                        });
                                        audioPlayer.resume();
                                        _animationController.forward();
                                      }
                                    },
                                    child: AnimatedIcon(
                                      icon: AnimatedIcons.play_pause,
                                      progress: _animationController,
                                      color: bluePurple,
                                      size: 50,
                                    )),
                            Expanded(
                              child: Slider(
                                onChanged: (value) {
                                  audioPlayer
                                      .seek(Duration(seconds: value.toInt()));
                                },
                                onChangeEnd: (double value) {
                                  // audioPlayer
                                  //     .seek(Duration(seconds: value.toInt()));
                                },
                                value: playerValue.inSeconds.toDouble(),
                                min: 0,
                                max: max.toDouble(),
                                activeColor: bluePurple,
                                thumbColor: bluePurple,
                              ),
                            )
                          ],
                        )),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: CustomText(
                          // widget.message.id +
                          audioTime,
                          fontSize: 16,
                          color: bluePurple,
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
