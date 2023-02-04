// Got this code from https://stackoverflow.com/a/64763333/18190914

import 'package:flutter/material.dart';

import '../../../core/helpers/color_filter_gen.dart';

class ImageFilter extends StatelessWidget {
  double brightness, saturation, hue;
  Widget child;
  ImageFilter(
      {required this.brightness,
      required this.saturation,
      required this.hue,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
        colorFilter:
            ColorFilter.matrix(ColorFilterGenerator().brightnessAdjustMatrix(
          value: brightness,
        )),
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
                ColorFilterGenerator().saturationAdjustMatrix(
              value: saturation,
            )),
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
                value: hue,
              )),
              child: child,
            )));
  }
}
