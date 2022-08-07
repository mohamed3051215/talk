import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  double opacity = 0, padding = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      setState(() {
        opacity = 1;
        padding = 8;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.only(top: padding),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 500),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "T", style: TextStyle(fontSize: 40, fontFamily: rMedium)),
            TextSpan(
                text: "a",
                style: TextStyle(
                    fontSize: 50, color: lightPurple, fontFamily: rRegular)),
            TextSpan(
                text: "lk",
                style: TextStyle(fontSize: 40, fontFamily: rMedium)),
          ]),
        ),
      ),
    );
  }
}
