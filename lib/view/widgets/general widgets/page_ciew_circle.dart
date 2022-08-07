import 'package:chat_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class PageCircle extends StatelessWidget {

  const PageCircle({Key? key, required this.value, required this.index}) : super(key: key);
  final int value;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value == index ? lightPurple : bluePurple,
        ),
      ),
    );
  }
}
