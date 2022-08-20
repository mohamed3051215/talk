import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.obs, required this.type})
      : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final bool obs;
  final TextInputType type;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          fillColor: textFieldColor,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
              color: lightPurple.withOpacity(.5),
              fontSize: 18,
              fontFamily: rRegular),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      obscureText: obs,
    );
  }
}
