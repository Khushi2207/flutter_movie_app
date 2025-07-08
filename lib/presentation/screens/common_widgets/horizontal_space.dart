import 'package:flutter/material.dart';
import '../../../utils/display_methods.dart';

class HorizontalSpace extends StatelessWidget {
  final double width;
  const HorizontalSpace({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    return SizedBox(width: width * variablePixelWidth);
  }
}