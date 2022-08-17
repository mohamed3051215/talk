// import 'dart:convert';
// import 'dart:math';

// import 'package:chat_app/core/controllers/chat_controller.dart';
// import 'package:chat_app/core/controllers/home_screen_controller.dart';
// import 'package:chat_app/view/screens/accept_audio_call_screen.dart';
// import 'package:chat_app/view/screens/accept_video_call_screen.dart';
// import 'package:chat_app/view/screens/settings_screen.dart';
// import 'package:chat_app/view/screens/voice_call_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../main.dart';
// import '../../view/screens/chat_screen.dart';
// import '../../view/screens/home_screen.dart';
// import '../models/user.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'custom_notificaon_channel_id',
//   'Notifiaion',
//   description: 'notificationfrom Your App Name.',
//   importance: Importance.high,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound("ringtone1"),
// );

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   print('Message In background: ${message.data}');
//   var initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettingsIOs = const IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOs,
//   );

//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String? payload) {
//     if (payload != null) {
//       Map<String, dynamic> data = json.decode(payload);
//       goToNextScreen(data, true);
//     }
//   });
//   flutterLocalNotificationsPlugin.show(
//       Random().nextInt(1000000000),
//       message.data['title'],
//       message.data["body"],
//       NotificationDetails(
//         android: AndroidNotificationDetails(channel.id, channel.name,
//             channelDescription: channel.description,
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound("ringtone1"),
//             fullScreenIntent: true),
//       ),
//       payload: json.encode(message.data));
// }

// void setupFcm() {
//   var initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettingsIOs = const IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOs,
//   );

//   //when the app is in foreground state and you click on notification.
//   flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String? payload) {
//     if (payload != null) {
//       Map<String, dynamic> data = json.decode(payload);
//       goToNextScreen(data, false);
//     }
//   });

//   //When the app is terminated, i.e., app is neither in foreground or background.
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     //Its compulsory to check if RemoteMessage instance is null or not.
//     if (message != null) {
//       goToNextScreen(message.data, false);
//     }
//   });

//   //When the app is in the background, but not terminated.
//   FirebaseMessaging.onMessageOpenedApp.listen(
//     (event) {
//       goToNextScreen(event.data, false);
//     },
//     cancelOnError: false,
//     onDone: () {
//       print("On Done Called");
//     },
//   );

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     goToNextScreen(message.data, false);
//   });
// }

// Future<void> deleteFcmToken() async {
//   return await FirebaseMessaging.instance.deleteToken();
// }

// Future<String> getFcmToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   return Future.value(token);
// }

// void goToNextScreen(Map<String, dynamic> data, bool isBackground) {
//   try {
//     print("should go to chat screen");
//     print("data is : " + data["sender data"].toString());
//     Map<String, dynamic> data2 = json.decode(data["sender data"]);
//     UserModel userModel = UserModel.fromJson(data2);
//     Get.put<ChatController>(ChatController(data2["uid"],
//         userModel: userModel, chatId: data2["chatId"]));
//     print("should go to chat screen2");
//     bool isInCall = false;
//     try {
//       isInCall = Get.find<ChatController>().isInCall;
//     } catch (e) {
//       print("Error" + e.toString());
//     }
//     if (isInCall) {
//       print("is in call");
//       return;
//     }

//     if (data["type"] == "chat") {
//       navigatorKey.currentState!
//           .push(MaterialPageRoute(builder: (context) => ChatScreen()));
//     } else if (data["type"] == "voicecall") {
//       navigatorKey.currentState!.push(MaterialPageRoute(
//           builder: (context) => AcceptAudioCallScreen(
//               channelName: data2["channel name"],
//               chatId: data2["chatId"],
//               token: data2["token"],
//               userModel: userModel,
//               isBackground: isBackground)));
//     } else if (data["type"] == "videocall") {
//       navigatorKey.currentState!.push(MaterialPageRoute(
//           builder: (context) => AcceptVideoCallScreen(
//               channelName: data2["channel name"],
//               chatId: data2["chatId"],
//               token: data2["token"],
//               userModel: userModel,
//               isBackground: isBackground)));
//     }
//   } catch (e) {
//     print("error is : " + e.toString());
//   }
// }
