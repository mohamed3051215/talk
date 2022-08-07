import 'package:chat_app/core/controllers/tab_controller.dart';
import 'package:chat_app/core/controllers/user_controller.dart';
import 'package:chat_app/core/helpers/show_error.dart';
import 'package:chat_app/view/screens/home_screen.dart';
import 'package:chat_app/view/screens/pick_image.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String code = "";
  signUp(String phoneNumber) async {
    try {
      printInfo(info: "Phone number is : " + phoneNumber);
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            UserCredential _userCredential =
                await _auth.signInWithCredential(credential);
            Get.put(UserController(
                userCredential: _userCredential, user: _userCredential.user));
            Get.put(CustomTabController());
            Get.to(() => HomeScreen());
          },
          verificationFailed: (FirebaseAuthException error) {
            printError(info: "Error in Auth" + error.message!);
            if (error.message.toString().contains("reCAPTCHA")) {
              showError(
                  "Invalid Robot Check, Please don't leave the checking operation");
              return;
            }
            showError(error.message!);
          },
          codeSent: (_code, tokin) {
            code = _code;
          },
          codeAutoRetrievalTimeout: (String newCode) {
            code = newCode;
          },
          timeout: Duration(seconds: 60));
    } catch (e) {
      Get.dialog(AlertDialog(
        title: CustomText("Error"),
        content: CustomText(e.toString()),
      ));
    }
  }

  submit(String value) async {
    try {
      await _auth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: code, smsCode: value));
      printInfo(info: _auth.currentUser!.uid.toString());
      // Get.put(UserController(
      //     userCredential: _userCredential, user: _userCredential.user));
      Get.to(() => PickImageScreen());
    } catch (r) {
      showError("Invalid Verification code, Please try again");
    }
  }

  login(String phone, String password) async {
    final QuerySnapshot data =
        await FirebaseFirestore.instance.collection("users").get();
    final List<QueryDocumentSnapshot<Object?>> data2 =
        data.docs.where((element) {
      if (element.data() != null) {
        return element["phone"] == phone;
      }
      return false;
    }).toList();
    printInfo(info: data2.toString() + " data2");
    if (data2.length == 0) {
      showError("This phone number isn't exist, Please Sign Up");
      return;
    } else if (data2[0]["password"] != password) {
      return;
    }
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential c) {},
        verificationFailed: (FirebaseAuthException e) {
          showError(e.message!);
        },
        codeSent: (verificationId, token) {
          code = verificationId;
        },
        codeAutoRetrievalTimeout: (_code) {
          code = _code;
        });
  }

  submitLogin(String value) async {
    try {
      UserCredential _userCredential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: code, smsCode: value));
      printInfo(info: _auth.currentUser!.uid.toString());
      Get.put(UserController(
          userCredential: _userCredential, user: _userCredential.user));
      Get.to(() => HomeScreen());
    } catch (r) {
      printError(info: "Error is : " + r.toString() + code);
      showError("Invalid Verification code, Please try again");
    }
  }
}
