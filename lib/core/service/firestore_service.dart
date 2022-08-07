import 'dart:io';

import 'package:chat_app/core/controllers/home_screen_controller.dart';
import 'package:chat_app/core/controllers/user_controller.dart';
import 'package:chat_app/core/helpers/show_error.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/core/service/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final StorageService _service = StorageService();
  addUser(String username, String phoneNumber, User user, String password,
      String image, String onesignalId) async {
    String id = user.uid;
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

  connect() {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"active": true});
    }
  }

  disconnect() {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"active": false});
    }
  }

  editName(String name) async {
    if (FirebaseAuth.instance.currentUser != null && name.isNotEmpty) {
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"username": name});
    }
  }

  editPassword(String password) async {
    if (FirebaseAuth.instance.currentUser != null && password.isNotEmpty) {
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"password": password});
    }
  }

  Future<UserModel> getUserModelFromId(String id) async {
    try {
      var data = await users.doc(id).get();
      final UserModel _userModel = UserModel(
          active: data["active"],
          id: data["uid"],
          oneSignalID: data['onesignal id'],
          image: data["image"],
          phoneNumber: data["phone"],
          username: data["username"]);
      return _userModel;
    } catch (e) {
      showError("User Not Found in firestore service");
      printError(info: e.toString());
      return UserModel(
          oneSignalID: null,
          active: false,
          id: "",
          image: "",
          phoneNumber: "",
          username: "");
    }
  }

  changeImage(File file) async {
    final String link = await _service.changeImage(file);
    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"image": link});
  }

  sendMessage(Message message, UserModel wantedUser, String chatId) async {
    final Map<String, dynamic> data = message.toJson();
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .doc(message.id)
        .set(data);
  }

  storeOneSignalKey(String key, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"onesignal id": key});
  }

  updateToken(String token) {
    final User? user = Get.find<UserController>().user;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"token": token});
    }
  }
}
