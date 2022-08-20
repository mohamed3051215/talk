import '../constants/colors.dart';
import '../../view/widgets/general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError(String error) {
  Get.dialog(AlertDialog(
    title: CustomText("Error", color: lightPurple, fontSize: 18),
    content: Container(
        child: CustomText(
      error,
      color: lightPurple,
      maxLines: 4,
    )),
    actions: [
      TextButton(
          onPressed: () {
            Get.back();
          },
          child: CustomText("Ok", color: lightPurple))
    ],
  ));
}
