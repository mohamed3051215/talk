import 'sign_up_controller.dart';
import '../enums/auth_operation.dart';
import '../service/auth_service.dart';
import '../../view/screens/otp_check_screen.dart';
import '../../view/screens/sign_up_screen.dart';
import '../../view/widgets/general%20widgets/custom_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  String dialCodee = "+20";
  bool validate = false;
  AuthService _auth = AuthService();
  signUp() {
    Get.put(SignUpController());
    Get.to(() => SignUpScreen());
  }

  set dialCode(String value) {
    dialCodee = value;
  }

  login() async {
    _validatePhone();
    await _auth.login(dialCodee + phone.text, password.text);

    Get.to(() => OTPCheckScreen(
          operation: AuthOperation.login,
        ));
  }

  _validatePhone() async {
    if (GetUtils.isPhoneNumber(dialCodee + phone.text)) {
      validate = true;
    } else {
      _showError("Invalid phone number, Please try again");
    }
  }

  _showError(String error) {
    validate = false;
    Get.dialog(CustomAlertDialog(error: error));
    return;
  }

  submit(String value) async {
    await _auth.submitLogin(value);
  }
}
