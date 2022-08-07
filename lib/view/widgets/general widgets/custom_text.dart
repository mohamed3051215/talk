import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(this.text,
      {Key? key,
      this.fontSize = 14,
      this.fontFamily = "",
      this.fontWeight = FontWeight.w400,
      this.letterSpacing = 1,
      this.wordSpacing = 1,
      this.color = Colors.white,
      this.textDirection = TextDirection.ltr,
      this.maxLines = 1,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);
  final String text;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final double letterSpacing, wordSpacing;
  final Color color;
  final TextDirection textDirection;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
