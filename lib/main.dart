import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/core/bindings/splash_binding.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';

import 'package:chat_app/core/service/message_storing_service.dart';
import 'package:chat_app/view/screens/accept_audio_call_screen.dart';
import 'package:chat_app/view/screens/accept_video_call_screen.dart';

import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/voice_call_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'core/controllers/tab_controller.dart';
import 'core/models/user.dart';
import 'core/service/firebase_messaging_service.dart';
import 'core/service/firebase_messaging_service_awesom_notification.dart';
import 'view/screens/controlling_screen.dart';

import 'view/screens/video_call_screen.dart';

late StreamSubscription<ReceivedAction> _actionStreamSubscription;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'custom_notification_channel_id',
            channelName: 'custom_notification_channel_id',
            channelDescription: 'Notifiation channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            playSound: true,
            soundSource: "resource://raw/ringtone1")
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  print("message token: ${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  getFcmToken();
  _setNotification();
  await MessageStoringService().init();
  runApp(MainApp());
}

_setNotification() async {
  _actionStreamSubscription =
      AwesomeNotifications().actionStream.listen((event) {
    print("action: ${event.payload}");
    print("sende data:  ${jsonDecode(event.payload!["data"]!)["sender data"]}");
    print(
        "sender type : ${jsonDecode(event.payload!["data"]!)["sender data"].runtimeType}");

    Map<String, dynamic> senderData =
        json.decode(jsonDecode(event.payload!["data"]!)["sender data"]);
    Map<String, dynamic> data = jsonDecode(event.payload!["data"]!);
    Get.put(ChatController(senderData['uid'],
        chatId: senderData['chatId'],
        userModel: UserModel.fromJson(senderData)));
    if (event.buttonKeyPressed == "answer") {
      print("answer");
      if (data['type'] == "voicecall") {
        Get.to(() => VoiceCallScreen(
              channelName2: senderData["channel name"],
              token2: senderData["token"],
              chatId: senderData["chatId"],
              userModel: UserModel.fromJson(senderData),
            ));
      } else if (data['type'] == "videocall") {
        Get.to(() => VideoCallScreen(
              channelName: senderData["channel name"],
              token: senderData["token"],
              chatId: senderData["chatId"],
              userModel: UserModel.fromJson(senderData),
            ));
      }
    }
  });
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late StreamSubscription<ReceivedAction> _stream;
  @override
  void initState() {
    super.initState();
    setupFcm();
    _checkOutNotification();
  }

  _checkOutNotification() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    // if (details!.didNotificationLaunchApp) {
    //   if (details.payload != null) {
    //     Map<String, dynamic> data = json.decode(details.payload!)['data'];
    //     Map<String, dynamic> senderData = json.decode(data['sender data']);
    //     print("sender data: $senderData");
    //     UserModel _userModel = UserModel.fromJson(senderData);
    //     print("user model: $_userModel");
    //     Get.put<ChatController>(ChatController(senderData["uid"],
    //         userModel: _userModel, chatId: senderData["chatId"]));
    //     print("chat id: ${senderData["chatId"]}");
    //     if (data['type'] == "chat") {
    //       Get.to(() => ChatScreen());
    //     } else if (data['type'] == "voicecall") {
    //       Get.to(() => AcceptAudioCallScreen(
    //             userModel: _userModel,
    //             channelName: senderData["channel name"],
    //             token: senderData["token"],
    //             chatId: senderData["chatId"],
    //             isBackground: true,
    //           ));
    //     } else if (data["type"] == "videocall") {
    //       Get.to(() => AcceptVideoCallScreen(
    //             userModel: _userModel,
    //             channelName: senderData["channel name"],
    //             chatId: senderData["chatId"],
    //             token: senderData["token"],
    //             isBackground: true,
    //           ));
    //     }
    //   } else
    //     print("payload is null");
    // } else {
    //   print("No Notification Opened app");
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CustomTabController());

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      home: ControllingScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: bgColor,
        primaryColor: bgColor,
      ),
      initialBinding: SplashBinding(),
    );
  }
}
