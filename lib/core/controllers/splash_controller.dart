import '../constants/titles.dart';
import 'login_controller.dart';
import '../../view/screens/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxInt index = 0.obs;

  PageController pageController = PageController(initialPage: 0);
  RxList<String> titls = titles.obs;

  next() {
    if (index.value == 2) {
      Get.put(LoginController());
      Get.offAll(() => LoginScreen());
    } else {
      index.value++;
      pageController.animateToPage(index.value,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    }
  }
}
