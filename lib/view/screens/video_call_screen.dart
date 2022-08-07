// import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:chat_app/core/constants/agora_keys.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../core/constants/colors.dart';
// import '../../core/constants/fonts.dart';
// import '../../core/controllers/chat_controller.dart';
// import '../widgets/general widgets/circle_button_for_call.dart';
// import '../widgets/general widgets/custom_text.dart';
// import '../widgets/general widgets/logo.dart';

// class VideoCallScreen extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<VideoCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//   final appId = agoraAppID;
//   final token = agoraChannelToken;
//   final channel = "mainchannel";
//   bool voiceOn = true;
//   bool videoOn = true;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     // retrieve permissions

//     await [Permission.microphone, Permission.camera].request();

//     //create the engine
//     _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
//     await _engine.enableVideo();
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print("local user $uid joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         userJoined: (int uid, int elapsed) {
//           print("remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print("remote user $uid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         warning: (WarningCode warning) {
//           printInfo(info: "Warning: $warning");
//         },
//         error: (ErrorCode error) {
//           printInfo(info: "Error: $error");
//         },
//       ),
//     );
//     Timer.periodic(Duration(seconds: 1), (timer) async {
//       if (!mounted) {
//         await _engine.leaveChannel();
//         timer.cancel();
//       }
//     });
//     await _engine.leaveChannel();
//     await _engine.joinChannel(token, channel, null, 0);
//   }

//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     final ChatController controller = Get.find<ChatController>();
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           _remoteUid == null
//               ? Container(
//                   height: Get.height,
//                   width: Get.width,
//                   child: Image.network(controller.userModel.image,
//                       fit: BoxFit.cover))
//               : Container(),
//           _remoteUid != null
//               ? Center(
//                   child: RtcRemoteView.SurfaceView(
//                     channelId: channel,
//                     uid: _remoteUid!,
//                   ),
//                 )
//               : Align(
//                   alignment: Alignment.center,
//                   child: CustomText(
//                     "Waiting for your friend to join...",
//                     color: lightPurple,
//                     fontSize: 30,
//                     maxLines: 3,
//                     fontFamily: rBold,
//                     textAlign: TextAlign.center,
//                   )),
// Obx(() => Positioned(
//       left: controller.position.value.dx,
//       top: controller.position.value.dy,
//       child: Draggable(
//         onDragUpdate: (DragUpdateDetails details) {
//           controller.position.value =
//               controller.position.value + details.delta;
//         },
//         feedback: Container(),
//         child: Container(
//           width: 100,
//           height: 150,
//           child: Center(
//             child: _localUserJoined
//                 ? RtcLocalView.SurfaceView()
//                 : CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     )),
//           Align(alignment: Alignment.topCenter, child: Logo()),
//           Positioned(
//               bottom: 20,
//               child: Container(
//                 width: Get.width,
//                 height: 180,
//                 child: Row(
//                   children: [
//                     CircleButtonForCall(
//                         icon: Icons.switch_camera,
//                         onPressed: () async {
//                           await _engine.switchCamera();
//                         }),
//                     CircleButtonForCall(
//                         icon: Icons.phone,
//                         size: 80,
//                         iconSize: 50,
//                         iconColor: Colors.red,
//                         onPressed: () async {
//                           await _engine.leaveChannel();
//                           Navigator.pop(context);
//                         }),
//                     CircleButtonForCall(
//                         icon: voiceOn ? Icons.volume_up : Icons.volume_off,
//                         onPressed: () async {
//                           if (voiceOn) {
//                             await _engine.muteLocalAudioStream(true);
//                           } else {
//                             await _engine.muteLocalAudioStream(false);
//                           }

//                           setState(() {
//                             voiceOn = !voiceOn;
//                           });
//                         }),
//                   ],
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid!,
//         channelId: channel,
//       );
//     } else {
//       return Container();
//     }
//   }
// }

import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/core/constants/agora_keys.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/fonts.dart';
import '../../core/controllers/chat_controller.dart';
import '../widgets/general widgets/circle_button_for_call.dart';
import '../widgets/general widgets/custom_text.dart';
import '../widgets/general widgets/logo.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import "package:http/http.dart" as http;

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine engine;
  int? remoteId;
  bool localUserJoined = false;
  String token = "";
  @override
  void initState() {
    initAgora();
    super.initState();
  }

  generareRandomString(int n) {
    var rand = Random();
    var code = StringBuffer();
    for (var i = 0; i < n; i++) {
      code.writeCharCode(rand.nextInt(26) + 65);
    }
    return code.toString();
  }

  initAgora() async {
    // String newToken = generareRandomString(90);
    await [Permission.microphone, Permission.camera].request();
    engine = await RtcEngine.create(agoraAppID);
    await engine.enableVideo();

    engine.setEventHandler(
        RtcEngineEventHandler(userJoined: (int uid, int elapsed) {
      printInfo(info: "local user joined with uid : " + uid.toString());
      setState(() {
        localUserJoined = true;
      });
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      printInfo(
          info: 'remote user joined uid: ' +
              channel +
              "and uid : " +
              uid.toString());
      setState(() {
        remoteId = uid;
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

    await engine.leaveChannel();

    RtcChannel.create("xyz");
    String tokens = await updateToken("763457832ghfewgqfjewt326", "123234123");
    setState(() {
      token = tokens;
    });
    await engine.joinChannel(token, "763457832ghfewgqfjewt326", null, 0);
  }

  updateToken(String channelName, String account) async {
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

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find<ChatController>();
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          remoteId == null
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  child: Image.network(controller.userModel.image,
                      fit: BoxFit.fill))
              : RtcRemoteView.SurfaceView(
                  channelId: token,
                  uid: remoteId!,
                ),
          remoteId != null
              ? Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    "Waiting for your friend to join...",
                    color: lightPurple,
                    fontSize: 30,
                    maxLines: 3,
                    fontFamily: rBold,
                    textAlign: TextAlign.center,
                  ))
              : Container(),
          Align(alignment: Alignment.topCenter, child: Logo()),
          Positioned(
              bottom: 100,
              child: Container(
                width: Get.width,
                height: 80,
                child: Row(
                  children: [
                    CircleButtonForCall(
                        icon: Icons.video_call, onPressed: () {}),
                    CircleButtonForCall(
                        icon: Icons.phone,
                        size: 80,
                        iconSize: 50,
                        iconColor: Colors.red,
                        onPressed: () {}),
                    CircleButtonForCall(
                        icon: Icons.volume_up_outlined, onPressed: () {}),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              )),
          Positioned(
              left: controller.position.value.dx,
              top: controller.position.value.dy - 110 + 20,
              child: Draggable(
                onDraggableCanceled: (v, o) {
                  controller.position.value = o;
                },
                feedback: Container(),
                child: Container(
                  width: 70,
                  height: 110,
                  child: localUserJoined
                      ? RtcLocalView.SurfaceView(
                          channelId: token,
                        )
                      : CircularProgressIndicator(),
                ),
              ))
        ],
      ),
    );
  }
}

// Positioned(
//               top: 150,
//               child: Container(
//                 width: Get.width,
//                 height: 200,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: Get.width - 100,
//                       child: CustomText(
//                         controller.userModel.username,
//                         maxLines: 3,
//                         textAlign: TextAlign.center,
//                         color: lightPurple,
//                         fontSize: 30,
//                         fontFamily: rBold,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Row(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     CustomText("00:05",
//                         color: lightPurple, fontSize: 40, fontFamily: rBold),
//                   ],
//                 ),
//               ))

// import 'dart:async';
// import 'dart:convert';

// import 'package:chat_app/core/constants/colors.dart';
// import 'package:chat_app/core/constants/enablex_keys.dart';
// import 'package:chat_app/core/controllers/home_screen_controller.dart';
// import 'package:chat_app/view/screens/home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enx_flutter_plugin/enx_flutter_plugin.dart';
// import 'package:enx_flutter_plugin/enx_player_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import "package:http/http.dart" as http;

// import '../../core/controllers/chat_controller.dart';
// import '../widgets/general widgets/logo.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   static String token = '';
//   static String roomId = '';
//   static String baseURL = "https://demo.enablex.io/";
//   static Map<String, String> headers = {
//     "x-app-id": enablexId,
//     "x-app-key": enablexKey,
//     "Content-Type": "application/json"
//   };
//   bool inited = false;
//   bool mutedVideo = false;
//   bool mutedAudio = false;
//   int remoteUser = 0;

//   @override
//   void initState() {
//     super.initState();
//     initEnx();
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       if (!mounted) {
//         FirebaseFirestore.instance
//             .collection("chat")
//             .doc(Get.find<ChatController>().chatId)
//             .update({"token": null, "room": null}).then((value) {
//           timer.cancel();
//         });
//       }
//     });
//   }

//   initEnx() async {
//     printInfo(info: "Started to init");
//     final HomeScreenController homeController =
//         Get.find<HomeScreenController>();
//     final ChatController chatController = Get.find<ChatController>();
//     final DocumentSnapshot<Map<String, dynamic>> dataCall =
//         await FirebaseFirestore.instance
//             .collection("chat")
//             .doc(chatController.chatId)
//             .get();
//     final Map<String, dynamic> firebaseData = dataCall.data()!;
//     if (firebaseData.keys.toList().contains("token") &&
//         firebaseData.keys.toList().contains("room") &&
//         firebaseData['room'] != null &&
//         firebaseData["token"] != null &&
//         firebaseData["token"].toString().isNotEmpty &&
//         firebaseData["room"].toString().isNotEmpty) {
//       printInfo(info: "Room Already created and now starting to get the token");
//       setState(() {
//         roomId = firebaseData['room'];
//         inited = true;
//       });
//       final _headers = headers;
//       _headers.addAll({
//         'Authorization':
//             'Basic NjJjNmY0NDQzMGMyMzUwOWQyNmJjMjI5OmVNeUJldmFqYWVhWHlteXB5NWVHeW51UHlIYVhhQWF2ZXRhdQ=='
//       });
//       final Map<String, dynamic> values = {
//         'user_ref': "2236",
//         "role": "participant",
//         "name": homeController.userModel!.username
//       };
//       final http.Response tokenResponse = await http.post(
//           Uri.parse("https://api.enablex.io/video/v2/rooms/$roomId/tokens"),
//           headers: _headers,
//           body: json.encode(values));
//       if (tokenResponse.statusCode == 200) {
//         final Map<String, dynamic> data2 = json.decode(tokenResponse.body);
//         printInfo(
//             info: "Token got successfully and token is ${data2['token']}");
//         setState(() {
//           token = data2['token'];
//           inited = true;
//         });
//       }
//       initEnxPlugin();
//       setEventHandler();

//       return;
//     }
//     printInfo(info: "Room are not created yet, creating room");
//     final Map<String, dynamic> bodyOfCreatingRoom = {
//       "name": "Video Call",
//       "owner_ref": homeController.userModel!.id,
//       "settings": {
//         "description":
//             "Room for video call with ${chatController.userModel.username} by ${homeController.userModel!.username}",
//         "mode": "group",
//         "scheduled": false,
//         "adhoc": false,
//         "duration": 10,
//         "moderators": "1",
//         "participants": "1",
//         "auto_recording": false,
//         "quality": "SD"
//       },
//       "sip": {
//         "enabled": false,
//       },
//       "data": {
//         "custom_key": "",
//       }
//     };
//     final _headers = headers;
//     _headers.addAll({
//       'Authorization':
//           'Basic NjJjNmY0NDQzMGMyMzUwOWQyNmJjMjI5OmVNeUJldmFqYWVhWHlteXB5NWVHeW51UHlIYVhhQWF2ZXRhdQ=='
//     });
//     final http.Response response = await http.post(
//         Uri.parse("https://api.enablex.io/video/v2/rooms"),
//         headers: _headers,
//         body: json.encode(bodyOfCreatingRoom));
//     if (response.statusCode == 200) {
//       printInfo(info: "Room created successfully and now getting the token");
//       final Map<String, dynamic> data = json.decode(response.body);
//       final Map<String, dynamic> room = data['room'];
//       roomId = room['room_id'];
//       final Map<String, dynamic> values = {
//         'user_ref': "2236",
//         "role": "participant",
//         "name": homeController.userModel!.username
//       };
//       final http.Response tokenResponse = await http.post(
//           Uri.parse("https://api.enablex.io/video/v2/rooms/$roomId/tokens"),
//           headers: _headers,
//           body: json.encode(values));
//       if (tokenResponse.statusCode == 200) {
//         final Map<String, dynamic> data2 = json.decode(tokenResponse.body);
//         printInfo(
//             info:
//                 "Got the token successfully and now updating data in firebase token: ${data2['token']}");
//         FirebaseFirestore.instance
//             .collection("chat")
//             .doc(chatController.chatId)
//             .update({"room": roomId});
//         setState(() {
//           token = data2['token'];
//           inited = true;
//         });
//         initEnxPlugin();
//         setEventHandler();
//       } else {
//         printError(info: "Error in creating token");
//       }
//     } else {
//       printError(info: "error in creating room");
//     }
//   }

//   initEnxPlugin() async {
//     Map<String, dynamic> map2 = {
//       'minWidth': 100,
//       'minHeight': 180,
//       'maxWidth': 320,
//       'maxHeight': 720
//     };
//     Map<String, dynamic> map1 = {
//       'audio': true,
//       'video': true,
//       'data': true,
//       'framerate': 20,
//       'maxVideoBW': 1000,
//       'minVideoBW': 100,
//       'audioMuted': false,
//       'videoMuted': false,
//       'name': 'flutter',
//       'videoSize': map2
//     };
//     await EnxRtc.joinRoom(token, map1, {}, []);
//   }

//   setEventHandler() {
//     EnxRtc.onRoomConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onRoomConnectedFlutter${jsonEncode(map)}');
//       });
//       EnxRtc.publish();
//     };
//     EnxRtc.onPublishedStream = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onPublishedStream${jsonEncode(map)}');
//         EnxRtc.setupVideo(0, 0, true, 300, 200);
//       });
//     };
//     EnxRtc.onStreamAdded = (Map<dynamic, dynamic> map) {
//       print('onStreamAdded${jsonEncode(map)}');
//       print("onStreamAdded Id${map["streamId"]}");
//       String streamId = '';
//       setState(() {
//         streamId = map['streamId'];
//       });
//       EnxRtc.subscribe(streamId);
//     };
//     EnxRtc.onRoomError = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onRoomError${jsonEncode(map)}');
//       });
//     };
//     EnxRtc.onNotifyDeviceUpdate = (String deviceName) {
//       print('onNotifyDeviceUpdate$deviceName');
//     };
//     EnxRtc.onActiveTalkerList = (Map<dynamic, dynamic> map) {
//       print('onActiveTalkerList $map');
//       print('here 9');
//       final items = (map['activeList'] as List)
//           // ignore: unnecessary_lambdas, unnecessary_new
//           .map((i) => new ActiveListModel.fromJson(i));
//       // ignore: prefer_is_empty
//       if (items.length > 0) {
//         print('here 10');
//         setState(() {
//           remoteUser = items.toList()[0].streamId;
//         });
//       }
//     };
//     EnxRtc.onEventError = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onEventError${jsonEncode(map)}');
//       });
//     };
//     EnxRtc.onEventInfo = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onEventInfo${jsonEncode(map)}');
//       });
//     };
//     EnxRtc.onUserConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onUserConnected${jsonEncode(map)}');
//       });
//     };
//     EnxRtc.onUserDisConnected = (Map<dynamic, dynamic> map) {
//       setState(() {
//         print('onUserDisConnected${jsonEncode(map)}');
//       });
//     };
//     EnxRtc.onRoomDisConnected = (Map<dynamic, dynamic> map) {
//       Navigator.pop(context);
//       // setState(() {
//       //   print('onRoomDisConnected' + jsonEncode(map));
//       //   Navigator.pop(context, '/Conference');
//       // });
//     };
//     EnxRtc.onAudioEvent = (Map<dynamic, dynamic> map) {
//       print('onAudioEvent${jsonEncode(map)}');
//       setState(() {
//         if (map['msg'].toString() == "Audio Off") {
//           mutedAudio = true;
//         } else {
//           mutedAudio = false;
//         }
//       });
//     };
//     EnxRtc.onVideoEvent = (Map<dynamic, dynamic> map) {
//       print('onVideoEvent${jsonEncode(map)}');
//       setState(() {
//         if (map['msg'].toString() == "Video Off") {
//           mutedVideo = true;
//         } else {
//           mutedVideo = false;
//         }
//       });
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ChatController controller = Get.find<ChatController>();
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           Align(alignment: Alignment.topCenter, child: Logo()),
//           Obx(() => Positioned(
//                 left: controller.position.value.dx,
//                 top: controller.position.value.dy,
//                 child: Draggable(
//                   onDragUpdate: (DragUpdateDetails details) {
//                     controller.position.value =
//                         controller.position.value + details.delta;
//                   },
//                   feedback: Container(),
//                   child: Container(
//                     width: 50,
//                     child: AspectRatio(
//                       aspectRatio: 2.1,
//                       child: Container(
//                         width: 50,
//                         child: Center(
//                             child: EnxPlayerWidget(
//                           0,
//                           local: true,
//                         )),
//                       ),
//                     ),
//                   ),
//                 ),
//               )),
//           remoteUser != 0
//               ? EnxPlayerWidget(
//                   remoteUser,
//                   local: false,
//                 )
//               : Align(
//                   alignment: Alignment.center,
//                   child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }

// class ActiveList {
//   bool active;
//   List<ActiveListModel> activeList = [];
//   String event;

//   ActiveList(this.active, this.activeList, this.event);

//   factory ActiveList.fromJson(Map<dynamic, dynamic> json) {
//     return ActiveList(
//       json['active'] as bool,
//       (json['activeList'] as List).map((i) {
//         return ActiveListModel.fromJson(i);
//       }).toList(),
//       json['event'] as String,
//     );
//   }
// }

// class ActiveListModel {
//   String name;
//   int streamId;
//   String clientId;
//   String videoaspectratio;
//   String mediatype;
//   bool videomuted;

//   ActiveListModel(this.name, this.streamId, this.clientId,
//       this.videoaspectratio, this.mediatype, this.videomuted);

//   // convert Json to an exercise object
//   factory ActiveListModel.fromJson(Map<dynamic, dynamic> json) {
//     int sId = int.parse(json['streamId'].toString());
//     return ActiveListModel(
//       json['name'] as String,
//       sId,
// //      json['streamId'] as int,
//       json['clientId'] as String,
//       json['videoaspectratio'] as String,
//       json['mediatype'] as String,
//       json['videomuted'] as bool,
//     );
//   }
// }




