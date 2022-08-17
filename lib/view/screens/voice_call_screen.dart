import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/agora_keys.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/controllers/chat_controller.dart';
import '../../core/controllers/home_screen_controller.dart';
import '../../core/models/user.dart';
import '../../core/service/firestore_service.dart';
import 'package:http/http.dart' as http;

import '../../core/service/post_notification_service.dart';
import '../widgets/general widgets/circle_button_for_call.dart';
import '../widgets/general widgets/custom_text.dart';
import '../widgets/general widgets/logo.dart';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen(
      {Key? key, this.userModel, this.channelName2, this.chatId, this.token2})
      : super(key: key);
  final UserModel? userModel;
  final String? channelName2, chatId, token2;
  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late RtcEngine _engine;
  int? _remoteId;
  bool _localUserJoined = false, _voiceOn = true, _callStarted = false;
  String _token = "";
  String? _channelName;
  final ChatController _chatController = Get.find<ChatController>();
  String label = "Joining call...";
  String _callTime = "00:00";
  Timer? _callTimer;
  Duration _callDuration = Duration(seconds: 0);
  ChatController chatController = Get.find<ChatController>();
  @override
  void initState() {
    _initAgora();
    _setTimer();
    super.initState();
  }

  _updateCallTime() {
    if (!mounted) return;
    setState(() {
      _callTime =
          _callDuration.inMinutes.remainder(60).toString().padLeft(2, "0") +
              ":" +
              _callDuration.inSeconds.remainder(60).toString().padLeft(2, "0");
    });
  }

  _setTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        if (_callTimer != null) {
          _callTimer!.cancel();
        }
        FirestoreService.clearTokenAndRoomId(_chatController.chatId)
            .then((value) {
          timer.cancel();
        });
      } else {
        printInfo(info: "Local User joined : $_localUserJoined");
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
    _engine.setEventHandler(
        RtcEngineEventHandler(userJoined: (int uid, int elapsed) {
      printInfo(
          info: 'remote user joined uid: ' + "and uid : " + uid.toString());
      setState(() {
        _remoteId = uid;
        label = "";
        _callStarted = true;
      });
      _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        printInfo(info: "Timer called" + _callDuration.toString());
        setState(() {
          _callDuration += Duration(seconds: 1);
        });
        _updateCallTime();
      });
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      printInfo(info: "local user joined with uid : " + uid.toString());
      setState(() {
        _localUserJoined = true;
        label = "Ringnig...";
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      printInfo(
          info: "user left call and uid: " +
              uid.toString() +
              "and the reason is ${reason.name}");
      setState(() {
        _remoteId = null;
        label = "Your friend left the call...";
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        _callTimer!.cancel();
        _engine.leaveChannel();
      });

      FirestoreService.clearTokenAndRoomId(chatController.chatId).then((v) {
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
        });
      });
    }, error: (ErrorCode errorCode) {
      printInfo(
          info:
              "some error happened error code : ${errorCode.name} -${errorCode} ");
    }, warning: (WarningCode warning) {
      printInfo(
          info:
              "some warning happened error code : ${warning.name} - ${warning}");
    }));
  }

  _askForPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  _setEngineAndEnableAudio() async {
    _engine = await RtcEngine.create(agoraAppID);
    await _engine.enableAudio();
    await _engine.enableAudioVolumeIndication(20, 3, true);
    await _engine.adjustRecordingSignalVolume(200);
    await _engine.adjustPlaybackSignalVolume(200);
    await _engine.adjustAudioMixingVolume(200);
    // await _engine.adjustAudioMixingPlayoutVolume(100);
  }

  int _generateRandomNumber(size) {
    var rand = Random();
    var code = StringBuffer();
    for (var i = 0; i < size; i++) {
      code.writeCharCode(rand.nextInt(26) + 65);
    }
    return int.parse(code.toString());
  }

  _initAgora() async {
    await _askForPermissions();
    await _setEngineAndEnableAudio();
    _setAgoraEventHandler();
    if (widget.userModel != null &&
        widget.chatId != null &&
        widget.channelName2 != null &&
        widget.token2 != null) {
      // String token = await updateToken(widget.channelName2!, 0.toString());
      return _joinRoom({"token": widget.token2, "room": widget.channelName2});
    }
    final firebaseData = await FirestoreService.getChat(_chatController.chatId);
    if (_roomExists(firebaseData)) {
      return _joinRoom(firebaseData);
    }
    await _createAndJoinRoom();
    await _postCallNotification();
  }

  _postCallNotification() async {
    await PostNotificationService().postCallNotification(
        userModel: chatController.userModel!,
        token: _token,
        channelName: _channelName!,
        chatId: chatController.chatId,
        isVideo: false);
  }

  _joinRoom(firebaseData) async {
    setState(() {
      _channelName = firebaseData['room'];
      _token = firebaseData['token'];
    });
    await _engine.leaveChannel();
    await _engine.joinChannel(_token, _channelName!, null, 0);
    return;
  }

  _createAndJoinRoom() async {
    setState(() {
      _channelName = _generareRandomString(50);
    });
    String tokens = await updateToken(
        _channelName!, Get.find<HomeScreenController>().userModel!.id);
    FirestoreService.updateChat(
        _chatController.chatId, {"token": tokens, "room": _channelName});
    setState(() {
      _token = tokens;
    });
    await _engine.leaveChannel();
    await _engine.joinChannel(_token, _channelName!, null, 0);
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
    return json.decode(response.body)["token"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Container(
                height: Get.height,
                width: Get.width,
                child: Image.network(_chatController.userModel!.image,
                    fit: BoxFit.cover)),
            _callStarted
                ? Align(
                    alignment: Alignment(0, -0.5),
                    child: CustomText(
                      _callTime,
                      color: lightPurple,
                      fontSize: 45,
                      maxLines: 3,
                      fontWeight: FontWeight.w300,
                      textAlign: TextAlign.center,
                    ))
                : Center(),
            _remoteId != null || _remoteId != ""
                ? Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                // color: lightPurple,
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: bluePurple),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ],
                        )),
                  )
                : Container(),
            Align(alignment: Alignment.topCenter, child: Logo()),
            Positioned(
                bottom: 20,
                child: Container(
                  width: Get.width,
                  height: 180,
                  child: Row(
                    children: [
                      CircleButtonForCall(
                          icon: Icons.phone,
                          iconColor: Colors.red,
                          onPressed: () async {
                            await _engine.leaveChannel();
                            Navigator.pop(context);
                          }),
                      CircleButtonForCall(
                          icon: _voiceOn ? Icons.volume_up : Icons.volume_off,
                          onPressed: () async {
                            if (_voiceOn) {
                              await _engine.muteLocalAudioStream(true);
                            } else {
                              await _engine.muteLocalAudioStream(false);
                            }

                            setState(() {
                              _voiceOn = !_voiceOn;
                            });
                          }),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                )),
          ],
        ));
  }
}
