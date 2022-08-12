import 'dart:convert';

import 'package:chat_app/core/bindings/splash_binding.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/view/screens/accept_audio_call_screen.dart';
import 'package:chat_app/view/screens/accept_video_call_screen.dart';

import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/voice_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/controllers/tab_controller.dart';
import 'core/models/user.dart';
import 'core/service/firebase_messaging_service.dart';
import 'view/screens/controlling_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'view/screens/video_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print("message token: ${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  getFcmToken();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    setupFcm();
    _checkOutNotification();
  }

  _checkOutNotification() async {
    var details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    if (details!.didNotificationLaunchApp) {
      if (details.payload != null) {
        Map<String, dynamic> data = json.decode(details.payload!);
        Map<String, dynamic> senderData = json.decode(data['sender data']);
        print("sender data: $senderData");
        UserModel _userModel = UserModel.fromJson(senderData);
        print("user model: $_userModel");
        Get.put<ChatController>(ChatController(senderData["uid"],
            userModel: _userModel, chatId: senderData["chatId"]));
        print("chat id: ${senderData["chatId"]}");
        if (data['type'] == "chat") {
          Get.to(() => ChatScreen());
        } else if (data['type'] == "voicecall") {
          Get.to(() => AcceptAudioCallScreen(
                userModel: _userModel,
                channelName: senderData["channel name"],
                token: senderData["token"],
                chatId: senderData["chatId"],
                isBackground: true,
              ));
        } else if (data["type"] == "videocall") {
          Get.to(() => AcceptVideoCallScreen(
                userModel: _userModel,
                channelName: senderData["channel name"],
                chatId: senderData["chatId"],
                token: senderData["token"],
                isBackground: true,
              ));
        }
      } else
        print("payload is null");
    } else {
      print("No Notification Opened app");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put<HomeScreenController>(HomeScreenController());
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
