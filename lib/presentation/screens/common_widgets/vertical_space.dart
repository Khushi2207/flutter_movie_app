import 'package:flutter/material.dart';
import '../../../utils/display_methods.dart';

class VerticalSpace extends StatelessWidget {
  final double height;
  const VerticalSpace({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    double getVariablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    return Container(height: height * getVariablePixelHeight);
  }
}