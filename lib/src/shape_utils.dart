import 'package:flutter/widgets.dart';

Size clampSize(Size input, {double min = 80, double max = 150}) {
  final double width = input.width.clamp(min, max);
  final double height = input.height.clamp(min, max);
  return Size(width, height);
}