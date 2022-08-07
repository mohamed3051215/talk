import 'package:chat_app/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  UserCredential? userCredential;
  User? user;
  UserController({this.userCredential, this.user});

  late UserModel userModel;
  @override
  Future<void> onInit() async {
    super.onInit();
    if (user != null) {
      final data = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      userModel = UserModel(
          id: user!.uid,
          active: true,
          oneSignalID: data["onesignal id"],
          image: data.data()!['image'],
          phoneNumber: data.data()!['phone'],
          username: data.data()!['username']);
    }else{

    }
  }
}
