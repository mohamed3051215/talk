import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/controllers/login_controller.dart';
import '../../core/controllers/sign_up_controller.dart';
import '../../core/enums/auth_operation.dart';
import '../widgets/general%20widgets/custom_text.dart';
import '../widgets/general%20widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPCheckScreen extends StatelessWidget {
  OTPCheckScreen({Key? key, required this.operation}) : super(key: key);
  final AuthOperation operation;

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final SignUpController contorller = Get.put(SignUpController());
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(235, 236, 237, 1),
    borderRadius: BorderRadius.circular(5.0),
  );
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
        appBar: AppBar(
          title: Logo(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: BackButton(
            color: lightPurple,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomText(
                  "Verifiy phone number",
                  color: lightPurple,
                  fontFamily: rBold,
                  fontSize: 30,
                ),
              )),
              Container(
                width: Get.width / 1.3,
                child: Pinput(
                  length: 6,
                  showCursor: true,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  defaultPinTheme:
                      PinTheme(height: 40.0, decoration: pinPutDecoration),
                  submittedPinTheme: PinTheme(
                      height: 40,
                      decoration: pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                  onCompleted: (String value) {
                    printInfo(info: "OTP: $value");
                    if (operation == AuthOperation.signUp) {
                      contorller.submit(value);
                    } else {
                      loginController.submit(value);
                    }
                  },
                  
                  followingPinTheme: PinTheme(
                    height: 40,
                    decoration: pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(.5),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
