import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import '../controllers/chat_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../../view/screens/accept_audio_call_screen.dart';
import '../../view/screens/accept_video_call_screen.dart';
import '../../view/screens/settings_screen.dart';
import '../../view/screens/voice_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../view/screens/chat_screen.dart';
import '../../view/screens/home_screen.dart';
import '../models/user.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'custom_notification_channel_id',
          channelName: 'custom_notification_channel_id',
          channelDescription: 'Notification chaasnnel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
        )
      ],
      // Channel groups are only visual and are not required

      debug: true);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(100000),
        channelKey: 'custom_notification_channel_id',
        title: 'Simple Notification',
        body: 'Simple body',
        // fullScreenIntent: true,
        payload: {"data": json.encode(message.data)},
        // wakeUpScreen: true,
      ),
      actionButtons: [
        NotificationActionButton(key: "answer", label: "Answer"),
        NotificationActionButton(
            key: "cancel",
            label: "Cancel",
            buttonType: ActionButtonType.DisabledAction),
      ]);
}

void setupFcm() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'custom_notification_channel_id',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  //When the app is terminated, i.e., app is neither in foreground or background.
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //Its compulsory to check if RemoteMessage instance is null or not.
    if (message != null) {
      goToNextScreen(message.data, false);
    }
  });

  //When the app is in the background, but not terminated.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      goToNextScreen(event.data, false);
    },
    cancelOnError: false,
    onDone: () {
      print("On Done Called");
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    goToNextScreen(message.data, false);
  });
}

Future<void> deleteFcmToken() async {
  return await FirebaseMessaging.instance.deleteToken();
}

Future<String> getFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return Future.value(token);
}

Future<void> goToNextScreen(
    Map<String, dynamic> data, bool isBackground) async {
  // try {
  print("should go to chat screen");
  print("data is : " + data["sender data"].toString());
  Map<String, dynamic> data2 = json.decode(data["sender data"]);
  UserModel userModel = UserModel.fromJson(data2);
  Get.delete<ChatController>();
  Get.put<ChatController>(ChatController(data2["uid"],
      userModel: userModel, chatId: data2["chatId"]));
  print("should go to chat screen2");
  bool isInCall = false;
  try {
    isInCall = Get.find<ChatController>().isInCall;
  } catch (e) {
    print("Error" + e.toString());
  }
  if (isInCall) {
    print("is in call");
    return;
  }

  if (data["type"] == "chat") {
  } else if (data["type"] == "voicecall") {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => AcceptAudioCallScreen(
            channelName: data2["channel name"],
            chatId: data2["chatId"],
            token: data2["token"],
            userModel: userModel,
            isBackground: isBackground)));
  } else if (data["type"] == "videocall") {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => AcceptVideoCallScreen(
            channelName: data2["channel name"],
            chatId: data2["chatId"],
            token: data2["token"],
            userModel: userModel,
            isBackground: isBackground)));
  }
  // } catch (e) {
  //   print("error is : " + e.toString());
  // }
}
