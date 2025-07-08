import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/display_methods.dart';

class HeaderWidget extends StatefulWidget {
  final String heading;
  final double headingSize;
  final double headingHeight;
  final Color textColor;
  final Icon? icon;

  const HeaderWidget({
    required this.heading,
    this.headingSize = AppConstants.fontSizeLarge,
    this.headingHeight = 16.0,
    this.textColor = AppColors.white,
    this.icon,
    super.key
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.only(
          left: 14 * variablePixelWidth,
          top: 24 * variablePixelHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(widget.icon != null)
            IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColors.white,
                size: 24 * pixelMultiplier,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          Expanded(
            child: Text(
              widget.heading,
              softWrap: true,
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.headingSize,
                  fontWeight: FontWeight.bold,
                  height: widget.headingHeight * textFontMultiplier,
              )
            ),
          ),
        ],
      ),
    );
  }
}
