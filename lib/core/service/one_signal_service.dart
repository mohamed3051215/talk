import 'dart:math';

import 'package:chat_app/core/constants/one_signal_keys.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/enums/message_type.dart';
import 'package:chat_app/core/models/message.dart' as m;
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/core/service/firestore_service.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../enums/call_type.dart';

class OneSignalService {
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> init() async {
    OneSignal.shared.setRequiresUserPrivacyConsent(false);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.userProvidedPrivacyConsent();
    OneSignal.shared.setAppId(oneSignalID);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      try {
        print(Get.find<ChatController>().chatId);
        if ((event.notification.additionalData!)["uid"] ==
            Get.find<ChatController>().userModel.id) {
          event.complete(null);
        } else {
          event.complete(event.notification);
        }
      } catch (e) {
        print(e);
        event.complete(event.notification);
      }
    });
    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      Map additionalData = openedResult.notification.additionalData!;

      try {
        print(Get.find<ChatController>().chatId);
        if (additionalData['uid'] != Get.find<ChatController>().userModel) {
          final data = await FirebaseFirestore.instance
              .collection("users")
              .doc(Get.find<HomeScreenController>().userModel!.id)
              .collection("users")
              .doc(additionalData['uid'])
              .get();
          Get.delete<ChatController>();
          Get.put(ChatController(additionalData['uid']));

          Get.back();
          Get.to(ChatScreen());
        }
      } catch (e) {
        final data = await FirebaseFirestore.instance
            .collection("users")
            .doc(Get.find<HomeScreenController>().userModel!.id)
            .collection("users")
            .doc(additionalData['uid'])
            .get();
        UserModel userModel =
            await FirestoreService().getUserModelFromId(additionalData['uid']);
        Get.put(ChatController(additionalData['uid']));

        Get.to(ChatScreen());
      }
    });
    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {});
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      event.complete(event.notification);
    });
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      Get.context!,
      MaterialPageRoute<void>(builder: (context) => HomeScreen()),
    );
  }

  sendMessage(
      {required UserModel userModel, required m.Message message}) async {
    String label = "audio message";
    switch (message.type) {
      case MessageType.image:
        label = "image sent";
        break;
      case MessageType.video:
        label = "Video sent";
        break;
      case MessageType.text:
        label = message.text;
        break;
      case MessageType.audio:
        break;
      default:
    }

    final OSCreateNotification notification = OSCreateNotification(
        playerIds: [
          userModel.oneSignalID!,
          // Get.find<HomeScreenController>().userModel!.oneSignalID!
        ],
        content: label,
        heading: userModel.username,
        additionalData: {"uid": userModel.id},
        subtitle: label);
    OneSignal.shared.postNotification(notification).then(print);
    printInfo(info: "notification sent");
  }

  notifyCall(CallType callType, String oneSignalID) async {
    switch (callType) {
      case CallType.videoCall:
        OneSignal.shared.postNotification(
          OSCreateNotification(
              playerIds: [oneSignalID],
              content: "Video call",
              heading: Get.find<HomeScreenController>().userModel!.username,
              additionalData: {
                "uid": Get.find<HomeScreenController>().userModel!.id
              },
              subtitle: "Video call"),
        );
        break;
      case CallType.voiceCall:
        OneSignal.shared.postNotification(
          OSCreateNotification(
              playerIds: [oneSignalID],
              content: "Video call",
              heading: Get.find<HomeScreenController>().userModel!.username,
              additionalData: {
                "uid": Get.find<HomeScreenController>().userModel!.id
              },
              subtitle: "Video call"),
        );
        break;
      default:
        break;
    }
  }
}
