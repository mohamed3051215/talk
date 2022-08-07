import 'package:chat_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key,
      required this.isExists,
      required this.onPressed,
      required this.widget,
      required this.onPressStart,
      required this.onPressEnd})
      : super(key: key);
  final bool isExists;
  final Function onPressed;
  final Widget widget;
  final Function onPressStart;
  final Function onPressEnd;

  @override
  Widget build(BuildContext context) {
    return isExists
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: lightBlue, shape: BoxShape.circle),
            child: Center(
              child: GestureDetector(
                child: widget,
                onTap: () {
                  onPressed();
                },
                onTapDown: (TapDownDetails d) {
                  onPressStart();
                },
                onTapUp: (d) => onPressEnd(),
              ),
            ))
        : SizedBox();
  }
}
