import 'package:get/get.dart';

class CustomTabController extends GetxController {
  RxBool isContacts = true.obs;
  RxBool isShowed = false.obs;
  set isContact(value) {
    isContacts.value = value;
  }

  set showed(value) {
    isShowed.value = value;
  }
}
