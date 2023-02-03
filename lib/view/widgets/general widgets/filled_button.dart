import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton(
      {Key? key,
      required this.text,
      this.width = 100,
      this.height = 51,
      required this.onPressed})
      : super(key: key);
  final String text;
  final double width, height;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: () => onPressed(),
        color: lightPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: CustomText(
          text,
          fontFamily: rBold,
          fontSize: 18,
        ),
      ),
    );
  }
}
