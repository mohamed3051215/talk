import 'package:chat_app/core/enums/auth_operation.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/view/screens/login_screen.dart';
import 'package:chat_app/view/screens/otp_check_screen.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final AuthService _authService = AuthService();
  String dialCodee = "+20";
  bool validate = false;
  String code = "";
  login() {
    Get.to(() => LoginScreen());
  }

  signUp() async {
    await _validate();

    if (validate) {
      await _authService.signUp(dialCodee + phone.text);
      code = _authService.code;
      Get.to(() => OTPCheckScreen(
            operation: AuthOperation.signUp,
          ));
    }
  }

  submit(String value) {
    _authService.submit(value);
  }

  set dialCode(value) {
    dialCodee = value;
  }

  _validate() async {
    validate = true;
    _validateUsername().isNotEmpty ? _showError(_validateUsername()) : null;
    if (validate) {
      (await _validatePhone()).isNotEmpty
          ? _showError((await _validatePhone()))
          : null;
    } else
      return;
    if (validate) {
      _validatePassword().isNotEmpty ? _showError(_validatePassword()) : null;
    } else
      return;
    if (validate) {
      _validateConfirmPassword().isNotEmpty
          ? _showError(_validateConfirmPassword())
          : null;
    } else
      return;
    if (validate) {
      (await _validatePhone2()).isNotEmpty
          ? _showError((await _validatePhone2()))
          : null;
    }
  }

  String _validateUsername() {
    if (GetUtils.isUsername(username.text)) {
      return "";
    }
    return "Invalid Username, Please try another one";
  }

  Future<String> _validatePhone() async {
    final query = await FirebaseFirestore.instance.collection("users").get();
    bool allow = query.docs.every((element) {
      return element.data()['phone'] == dialCodee + phone.text;
    });
    if (GetUtils.isPhoneNumber(dialCodee + phone.text)) {
      return "";
    }
    return "Invalid phone number, Please try again";
  }

  Future<String> _validatePhone2() async {
    final query = await FirebaseFirestore.instance.collection("users").get();
    List allow = query.docs.where((element) {
      return element.data()["phone"] == dialCodee + phone.text;
    }).toList();
    print(allow);
    if (allow.length == 0) {
      return "";
    }
    return "You already have an accound, Please login";
  }

  String _validatePassword() {
    if (password.text.length > 6) {
      printInfo(info: "Password is " + password.text);
      return "";
    }
    printInfo(info: "Password is " + password.text);
    return "Password is week, Please try another one stronger";
  }

  String _validateConfirmPassword() {
    if (confirmPassword.text == password.text) {
      return '';
    }
    return "Confirm password doesn't match password, Please try again";
  }

  _showError(String error) {
    validate = false;
    Get.dialog(CustomAlertDialog(error: error));
    return;
  }
}
