import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/core/constants/agora_keys.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/service/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/fonts.dart';
import '../../core/controllers/chat_controller.dart';
import '../../core/models/user.dart';
import '../widgets/general widgets/circle_button_for_call.dart';
import '../widgets/general widgets/custom_text.dart';
import '../widgets/general widgets/logo.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import "package:http/http.dart" as http;

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen(
      {Key? key, this.userModel, this.channelName2, this.chatId, this.token2})
      : super(key: key);
  final UserModel? userModel;
  final String? channelName2, chatId, token2;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine engine;

  int? remoteId;
  bool localUserJoined = false, voiceOn = true, videoOn = true;
  String token = "";
  String? channelName;
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    _initAgora();
    _setTimer();
    super.initState();
  }

  _setTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        FirebaseFirestore.instance
            .collection("chat")
            .doc(Get.find<ChatController>().chatId)
            .update({"token": null, "room": null}).then((value) {
          timer.cancel();
        });
      } else {
        printInfo(info: "Local User joined : $localUserJoined");
      }
    });
  }

  _generareRandomString(int n) {
    var rand = Random();
    var code = StringBuffer();
    for (var i = 0; i < n; i++) {
      code.writeCharCode(rand.nextInt(26) + 65);
    }
    return code.toString();
  }

  _setAgoraEventHandler() {
    engine.setEventHandler(
        RtcEngineEventHandler(userJoined: (int uid, int elapsed) {
      printInfo(
          info: 'remote user joined uid: ' +
              // channel +
              "and uid : " +
              uid.toString());
      setState(() {
        remoteId = uid;
      });
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      printInfo(info: "local user joined with uid : " + uid.toString());
      setState(() {
        localUserJoined = true;
        // remoteId = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      printInfo(
          info: "user left call and uid: " +
              uid.toString() +
              "and the reason is ${reason.name}");
      setState(() {
        remoteId = null;
      });
    }, error: (ErrorCode errorCode) {
      printInfo(
          info:
              "some error happened error code : ${errorCode.name} -${errorCode} ");
    }, warning: (WarningCode warning) {
      printInfo(
          info:
              "some warning happened error code : ${warning.name} - ${warning}");
    }, tokenPrivilegeWillExpire: (String? token) {
      printInfo(info: "token will expire : $token");
    }));
  }

  _askForPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  _setEngineAndEnableVideo() async {
    engine = await RtcEngine.create(agoraAppID);
    await engine.enableVideo();
  }

  _initAgora() async {
    await _askForPermissions();
    await _setEngineAndEnableVideo();
    _setAgoraEventHandler();
    if (widget.userModel != null &&
        widget.chatId != null &&
        widget.channelName2 != null &&
        widget.token2 != null) {
      return _joinRoom({"token": widget.token2, "room": widget.channelName2});
    }
    final firebaseData = await FirestoreService.getChat(chatController.chatId);
    if (_roomExists(firebaseData)) {
      return _joinRoom(firebaseData);
    }
    _createAndJoinRoom();
  }

  _joinRoom(firebaseData) async {
    setState(() {
      channelName = firebaseData['room'];
      token = firebaseData['token'];
    });
    await engine.leaveChannel();
    await engine.joinChannel(token, channelName!, null, 0);
    return;
  }

  _createAndJoinRoom() async {
    setState(() {
      channelName = _generareRandomString(50);
    });

    String tokens = await updateToken(
        channelName!, Get.find<HomeScreenController>().userModel!.id);
    FirestoreService.updateChat(
        chatController.chatId, {"token": tokens, "room": channelName});
    setState(() {
      token = tokens;
    });

    await engine.leaveChannel();
    await engine.joinChannel(token, channelName!, null, 0);
  }

  bool _roomExists(firebaseData) {
    return firebaseData.keys.toList().contains("token") &&
        firebaseData.keys.toList().contains("room") &&
        firebaseData['room'] != null &&
        firebaseData["token"] != null &&
        firebaseData["token"].toString().isNotEmpty &&
        firebaseData["room"].toString().isNotEmpty;
  }

  Future<String> updateToken(String channelName, String account) async {
    final Uri url = Uri.parse(
        "https://drf-watchmate.herokuapp.com/watch/token/?app_id=ff6db955480642b0bf9292a13dcd0ea3&APC=9f0e95a4281c453e8d2f672da396faf9&channel_name=" +
            channelName +
            "&account=" +
            0.toString());
    final http.Response response = await http.get(url);
    printInfo(info: response.body);
    printInfo(info: url.toString());
    return json.decode(response.body)["token"];
  }

  Widget _remoteVideo() {
    if (remoteId != "" && remoteId != null && channelName != null) {
      return RtcRemoteView.SurfaceView(
        uid: remoteId!,
        channelId: channelName!,
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          remoteId == null || remoteId == ""
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  child: Image.network(chatController.userModel!.image,
                      fit: BoxFit.cover))
              : Container(),
          remoteId != null && remoteId != ""
              ? Center(
                  child: RtcRemoteView.SurfaceView(
                    channelId: channelName!,
                    uid: remoteId!,
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    "Waiting for your friend to join...",
                    color: lightPurple,
                    fontSize: 30,
                    maxLines: 3,
                    fontFamily: rBold,
                    textAlign: TextAlign.center,
                  )),
          Align(alignment: Alignment.topCenter, child: Logo()),
          remoteId != null && remoteId != ""
              ? _remoteVideo()
              : Align(alignment: Alignment.center, child: Center()),
          Positioned(
              bottom: 20,
              child: Container(
                width: Get.width,
                height: 180,
                child: Row(
                  children: [
                    CircleButtonForCall(
                        icon: Icons.switch_camera,
                        onPressed: () async {
                          await engine.switchCamera();
                        }),
                    CircleButtonForCall(
                        icon: Icons.phone,
                        size: 80,
                        iconSize: 50,
                        iconColor: Colors.red,
                        onPressed: () async {
                          await engine.leaveChannel();
                          Navigator.pop(context);
                        }),
                    CircleButtonForCall(
                        icon: voiceOn ? Icons.volume_up : Icons.volume_off,
                        onPressed: () async {
                          if (voiceOn) {
                            await engine.muteLocalAudioStream(true);
                          } else {
                            await engine.muteLocalAudioStream(false);
                          }

                          setState(() {
                            voiceOn = !voiceOn;
                          });
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              )),
          Obx(() => Positioned(
                left: chatController.position.value.dx,
                top: chatController.position.value.dy,
                child: Draggable(
                  onDragUpdate: (DragUpdateDetails details) {
                    chatController.position.value =
                        chatController.position.value + details.delta;
                  },
                  feedback: Container(),
                  child: Container(
                    width: 100,
                    height: 170,
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: Container(
                        width: 50,
                        child: Center(
                          child: localUserJoined
                              ? RtcLocalView.SurfaceView(
                                  channelId: channelName,
                                  mirrorMode: VideoMirrorMode.Enabled,
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
