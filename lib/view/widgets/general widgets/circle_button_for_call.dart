import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/constants/colors.dart';

class CircleButtonForCall extends StatelessWidget {
  final double size;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final double iconSize;
  final Function onPressed;
  const CircleButtonForCall(
      {Key? key,
      this.size = 60,
      required this.icon,
      this.iconColor = lightBlue,
      this.buttonColor = lightPurple,
      this.iconSize = 40,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          )),
    );
  }
}
