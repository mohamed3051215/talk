import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/login_controller.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text_field.dart';
import 'package:chat_app/view/widgets/general%20widgets/filled_button.dart';
import 'package:chat_app/view/widgets/general%20widgets/logo.dart';
import 'package:chat_app/view/widgets/general%20widgets/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return Scaffold(
      backgroundColor: bgColor,
        appBar: AppBar(
          title: Logo(),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: CustomText(
                    "Login",
                    fontFamily: osSemiBold,
                    fontSize: 48,
                    color: lightPurple,
                  )),
                  const SizedBox(
                    height: 17,
                  ),
                  PhoneTextField(
                    controller: controller.phone,
                    controllerx: controller,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  CustomTextField(
                      controller: controller.password,
                      hintText: "password",
                      type: TextInputType.name,
                      obs: true),
                  const SizedBox(
                    height: 17,
                  ),
                  FilledButton(
                      onPressed: () => controller.login(), text: "login"),
                  SizedBox(
                    height: 17,
                  ),
                  MaterialButton(
                      onPressed: () => controller.signUp(),
                      child: CustomText(
                        "has no account? create on",
                        fontFamily: rBold,
                        fontSize: 18,
                        color: lightPurple,
                      )),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
        ));
  }
}
