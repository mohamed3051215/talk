import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key, required this.error}) : super(key: key);
  final String error;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: CustomText(
              "Ok",
              color: lightPurple,
              fontFamily: rMedium,
            ))
      ],
      title: CustomText(
        "Some Thing wrong",
        color: lightPurple,
        fontFamily: rRegular,
      ),
      content: Container(
        height: 40,
        child: CustomText(
          error,
          color: lightPurple,
          letterSpacing: .3,
          fontSize: 19,
          maxLines: 5,
        ),
      ),
    );
  }
}
