import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/sign_up_controller.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text_field.dart';
import 'package:chat_app/view/widgets/general%20widgets/filled_button.dart';
import 'package:chat_app/view/widgets/general%20widgets/logo.dart';
import 'package:chat_app/view/widgets/general%20widgets/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  SignUpController controller = Get.find<SignUpController>();
  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.find<SignUpController>();
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
          child: SingleChildScrollView(
            child: Container(
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  Center(
                      child: CustomText(
                    "SignUp",
                    fontFamily: osSemiBold,
                    fontSize: 48,
                    color: lightPurple,
                  )),
                  const SizedBox(
                    height: 17,
                  ),
                  CustomTextField(
                      controller: controller.username,
                      type: TextInputType.emailAddress,
                      hintText: "username",
                      obs: false),
                  const SizedBox(
                    height: 17,
                  ),
                  PhoneTextField(
                      controller: controller.phone, controllerx: controller),
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
                  CustomTextField(
                      controller: controller.confirmPassword,
                      hintText: "confirm password",
                      type: TextInputType.name,
                      obs: true),
                  const SizedBox(
                    height: 17,
                  ),
                  FilledButton(
                      onPressed: () => controller.signUp(), text: "SignUp"),
                  SizedBox(
                    height: 17,
                  ),
                  MaterialButton(
                      onPressed: () => controller.login(),
                      child: CustomText(
                        "has an account? login",
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
