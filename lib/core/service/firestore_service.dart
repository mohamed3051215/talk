import 'dart:io';

import '../controllers/home_screen_controller.dart';
import '../controllers/user_controller.dart';
import '../helpers/show_error.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirestoreService {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  static addUser(String username, String phoneNumber, User user,
      String password, String image, String onesignalId) async {
    String id = user.uid;
    final CollectionReference users =
        FirebaseFirestore.instance.collection("users");
    final Map<String, dynamic> data = {
      "username": username,
      "password": password,
      "uid": user.uid,
      "onesignal id": onesignalId,
      "phone": phoneNumber,
      "active": true,
      "image": image
    };

    await users.doc(id).set(data);
  }

  static connect() {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"active": true});
    }
  }

  static disconnect() {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"active": false});
    }
  }

  static editName(String name) async {
    if (FirebaseAuth.instance.currentUser != null && name.isNotEmpty) {
      final CollectionReference users =
          FirebaseFirestore.instance.collection("users");
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"username": name});
    }
  }

  static editPassword(String password) async {
    if (FirebaseAuth.instance.currentUser != null && password.isNotEmpty) {
      final CollectionReference users =
          FirebaseFirestore.instance.collection("users");
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"password": password});
    }
  }

  static Future<UserModel> getUserModelFromId(String id) async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection("users");
      var data = await users.doc(id).get();
      final UserModel _userModel = UserModel(
          firebaseToken: data["firebaseToken"] as String,
          active: data["active"],
          id: data["uid"],
          image: data["image"],
          phoneNumber: data["phone"],
          username: data["username"]);
      return _userModel;
    } catch (e) {
      showError("User Not Found in firestore service");
      print(e.toString());
      return UserModel(
          firebaseToken: '',
          active: false,
          id: "",
          image: "",
          phoneNumber: "",
          username: "");
    }
  }

  static changeImage(File file) async {
    final StorageService _service = StorageService();
    final CollectionReference users =
        FirebaseFirestore.instance.collection("users");
    final String link = await _service.changeImage(file);
    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"image": link});
  }

  static sendMessage(
      Message message, UserModel wantedUser, String chatId) async {
    final Map<String, dynamic> data = message.toJson();
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .doc(message.id)
        .set(data);
  }

  static storeOneSignalKey(String key, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"onesignal id": key});
  }

  static updateToken(String token) {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"token": token});
    }
  }

  static Future<Map<String, dynamic>> getChat(String chatId) async {
    final dataCall =
        await FirebaseFirestore.instance.collection("chat").doc(chatId).get();
    return dataCall.data()!;
  }

  static void updateChat(String chatId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .update(data);
  }

  static Future<void> clearTokenAndRoomId(chatId) async {
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .update({"token": null, "room": null});
    return;
  }

  static Future<void> rejectCall({required String chatId}) async {
    return await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .update({"rejected": true});
  }

  static Future<void> resetCallRejection({required String chatId}) async {
    return await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .update({"rejected": false});
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> callRejectionSnapshots(
      {required String chatId}) {
    return FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .snapshots();
  }
}
