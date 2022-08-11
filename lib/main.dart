import 'dart:convert';

import 'package:chat_app/core/bindings/splash_binding.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/view/screens/accept_audio_call_screen.dart';

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
          Get.to(() => VoiceCallScreen());
        } else if (data["type"] == "videocall") {
          Get.to(() => VideoCallScreen());
        }
      } else
        print("payload is  null");
    } else {
      print("No notification launched app");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put<HomeScreenController>(HomeScreenController());
    Get.put(CustomTabController());

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      // home: ControllingScreen(),
      home: AcceptAudioCallScreen(
          userModel: UserModel.fromJson({
        "uid": "6nWStqMNwUZAiwyGjlcwlv4eQPJ2",
        "image":
            "https://firebasestorage.googleapis.com/v0/b/chat-app-ebb78.appspot.com/o/Users%20Images%2FAaW1Xb8zIAaJraQflgmFsVY76hr1.jpg?alt=media&token=d6f4ef2f-a757-49d2-9119-117365f2c707",
        "phone": "+2001556462676",
        "username": "محمد ايمن عبدالعليم",
        "active": false,
        "onesignal id": "7ff51c64-7c77-4404-b555-89cb92883a34",
        "chatId": "aG6tP4SPkSdSFBkMaDYI"
      })),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: bgColor,
        primaryColor: bgColor,
      ),
      initialBinding: SplashBinding(),
    );
  }
}
