import '../../../core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        Get.back();
      },
      color: lightPurple,
    );
  }
}
