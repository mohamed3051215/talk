import 'dart:async';
import 'dart:convert';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/controllers/login_controller.dart';
import 'package:chat_app/core/controllers/profile_controller.dart';
import 'package:chat_app/core/controllers/tab_controller.dart';
import 'package:chat_app/core/controllers/user_controller.dart';
import 'package:chat_app/core/models/contact.dart';
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/core/service/firebase_messaging_service.dart';
import 'package:chat_app/core/service/firestore_service.dart';
import 'package:chat_app/core/service/user_status_service.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/login_screen.dart';
import 'package:chat_app/view/screens/profile_screen.dart';
import 'package:chat_app/view/screens/settings_screen.dart';
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
  logOut() async {
    await _auth.signOut();
    Get.put(LoginController());
    Get.to(() => LoginScreen());
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _checkForMessage();
    _askForPermissions();
    await _setUserModel();
    _setContacts();

    await _userStatuesService.setupMyUser();
    Get.put(UserController(user: FirebaseAuth.instance.currentUser));
    isMenuOpened.value = Get.find<CustomTabController>().isShowed.value;
    Get.find<CustomTabController>().isShowed.listen((p0) {
      isMenuOpened.value = p0;
      printInfo(info: isMenuOpened.value.toString());
    });
    var details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    if (details!.didNotificationLaunchApp) {
      if (details.payload != null)
        {
          Map<String , dynamic> data = json.decode(details.payload!);
          if(data['type'] == "chat"){
            Get.put<ChatController>(ChatController(data["sender id"]));
            
          }
        }
      else
        print("hellno0000000000000000 payload null");
    } else {
      print("hellnoooooooooooooooooooooooooooo");
    }
    await OneSignal.shared.setExternalUserId(userModel!.id);
    OneSignal.shared.getDeviceState().then((value) {
      FirestoreService.storeOneSignalKey(value!.userId!, userModel!.id);
    });
  }

  _checkForMessage() async {
    printInfo(info: "checkForMessage");
    print("checkForMessage");
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      printInfo(info: "initialMessage != null");
      print("initialMessage != null");
      final String uid = initialMessage.data['from'];
      Get.put<ChatController>(ChatController(uid));
      Get.to(ChatScreen());
    } else {
      printInfo(info: "initialMessage is null");
      print("initialMessage is null");
    }
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
        ChatContact contact =
            ChatContact(contactUser: userModels, messagesNotSeen: 0);
        contacts.add(contact);
        final data = FirebaseFirestore.instance
            .collection("users")
            .doc(userModel!.id)
            .collection("users")
            .doc(contact.contactUser.id)
            .get()
            .then((data) {
          allUsersChatId.add(data["chatId"]);
        });
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
