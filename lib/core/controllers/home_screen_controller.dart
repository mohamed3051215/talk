import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'chat_controller.dart';
import 'login_controller.dart';
import 'profile_controller.dart';
import 'tab_controller.dart';
import 'user_controller.dart';
import '../models/contact.dart';
import '../models/user.dart';
import '../service/firebase_messaging_service.dart';
import '../service/firestore_service.dart';
import '../service/user_status_service.dart';
import '../../view/screens/chat_screen.dart';
import '../../view/screens/login_screen.dart';
import '../../view/screens/profile_screen.dart';
import '../../view/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isMenuOpened = false.obs;
  UserModel? userModel;
  StreamSubscription? chatSubscription;
  final UserStatuesService _userStatuesService = UserStatuesService();
  RxList<ChatContact> contacts = <ChatContact>[].obs;

  final List<String> allUsersChatId = <String>[];
  RxList<Map<String, Stream<DatabaseEvent>>> activeUsers =
      <Map<String, Stream<DatabaseEvent>>>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // _checkOutNotification();
    _askForPermissions();
    await _setUserModel();
    _setContacts();

    await _userStatuesService.setupMyUser();
    _setUser();
    _setTabSettings();
    await _setOneSignalSettings();
    _initNotifications();
  }

  _initNotifications() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications(
            channelKey: 'basic_channel',
            permissions: [
              NotificationPermission.Alert,
              NotificationPermission.Sound,
              NotificationPermission.Badge,
              NotificationPermission.CriticalAlert,
              NotificationPermission.Provisional,
              NotificationPermission.FullScreenIntent,
              NotificationPermission.Vibration
            ]);
      }
    });
  }

  logOut() async {
    await _auth.signOut();
    Get.put(LoginController());
    Get.to(() => LoginScreen());
  }

  _setUser() {
    Get.put(UserController(user: FirebaseAuth.instance.currentUser));
  }

  _setTabSettings() {
    isMenuOpened.value = Get.find<CustomTabController>().isShowed.value;
    Get.find<CustomTabController>().isShowed.listen((p0) {
      isMenuOpened.value = p0;
      printInfo(info: isMenuOpened.value.toString());
    });
  }

  // _checkOutNotification() async {
  //   var details = await FlutterLocalNotificationsPlugin()
  //       .getNotificationAppLaunchDetails();
  //   if (details!.didNotificationLaunchApp) {
  //     if (details.payload != null) {
  //       Map<String, dynamic> data = json.decode(details.payload!);
  //       if (data['type'] == "chat") {
  //         Map<String, dynamic> senderData = json.decode(data['sender data']);
  //         UserModel _userModel = UserModel.fromJson(senderData);

  //         Get.put<ChatController>(ChatController(senderData["uid"],
  //             userModel: _userModel, chatId: senderData["chatId"]));
  //         Get.to(() => ChatScreen());
  //       }
  //     } else
  //       print("hellno0000000000000000 payload null");
  //   } else {
  //     print("hellnoooooooooooooooooooooooooooo");
  //   }
  // }

  _setOneSignalSettings() async {
    await OneSignal.shared.setExternalUserId(userModel!.id);
    OneSignal.shared.getDeviceState().then((value) {
      FirestoreService.storeOneSignalKey(value!.userId!, userModel!.id);
    });
  }

  _setContacts() {
    chatSubscription = FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.id)
        .collection("users")
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) async {
      contacts.clear();
      allUsersChatId.clear();
      activeUsers.clear();
      event.docChanges.forEach((e) async {
        final UserModel userModels =
            await FirestoreService.getUserModelFromId(e.doc["uid"]);
        final data = await FirebaseFirestore.instance
            .collection("users")
            .doc(userModel!.id)
            .collection("users")
            .doc(userModels.id)
            .get();
        allUsersChatId.add(data["chatId"]);
        ChatContact contact = ChatContact(
            contactUser: userModels,
            messagesNotSeen: 0,
            chatId: data["chatId"]);
        contacts.add(contact);
        activeUsers.add(
            {userModels.id: _userStatuesService.userStatues(userModels.id)});
        update();
      });
    });
  }

  goProfile() {
    Get.put(ProfileController());
    Get.to(() => ProfileScreen(user: FirebaseAuth.instance.currentUser!));
  }

  _setUserModel() async {
    final User _user = FirebaseAuth.instance.currentUser!;
    userModel = await FirestoreService.getUserModelFromId(_user.uid);
  }

  goSettings() {
    Get.to(() => SettingsScreen());
  }

  _askForPermissions() async {
    List<Permission> requiredPermissions = [
      Permission.microphone,
      Permission.camera,
      Permission.storage,
      Permission.manageExternalStorage
    ];
    bool _shouldAsk = false;
    for (Permission permission in requiredPermissions) {
      bool permissionStatus = await permission.isGranted;
      if (permissionStatus != true) {
        _shouldAsk = true;
      }
    }
    _shouldAsk
        ? await requiredPermissions.request()
        : print("All permissions granted");
  }

  aboutUs() {
    Get.dialog(AboutDialog(
      applicationName: "Talk",
      applicationVersion: "1.0.1",
    ));
  }
}
