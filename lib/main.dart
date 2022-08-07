import 'dart:convert';
import 'package:chat_app/core/bindings/splash_binding.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/service/firestore_service.dart';
import 'package:chat_app/core/service/one_signal_service.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/models/user.dart';
import 'core/service/firebase_messaging_service.dart';
import 'view/screens/controlling_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("message token: ${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FirebaseMessagingService().init();
  // FirebaseMessaging.onBackgroundMessage();
  // OneSignalService().init();
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
    
  }

  @override
  Widget build(BuildContext context) {
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
