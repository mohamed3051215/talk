import 'package:chat_app/core/controllers/tab_controller.dart';
import 'package:chat_app/core/controllers/user_controller.dart';
import 'package:chat_app/view/screens/home_screen.dart';
import 'package:chat_app/view/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllingScreen extends StatelessWidget {
  const ControllingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SplashScreen();
    }
    Get.put(CustomTabController());
    Get.put(UserController(user: FirebaseAuth.instance.currentUser));
    return HomeScreen();
  }
}
