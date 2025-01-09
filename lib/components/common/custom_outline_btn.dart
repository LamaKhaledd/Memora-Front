import 'package:flutter/material.dart';
import 'package:memora/components/common/app_style.dart';
import 'package:memora/components/common/reusable_text.dart';

class CustomOutlineBtn extends StatelessWidget {
  const CustomOutlineBtn({
    Key? key,
    this.width,
    this.height,
    required this.text,
    this.onTap,
    required this.color,
    this.color2,
    this.titleFontSize,
    this.borderRadius, // Added parameter for title font size
  }) : super(key: key);

  final double? width;
  final double? height;
  final String text;
  final void Function()? onTap;
  final Color color;
  final Color? color2;
  final double? borderRadius;
  final double? titleFontSize; // Updated to accept nullable double

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color2,

          borderRadius: BorderRadius.circular(
              borderRadius ?? 0.0), // Add this line to specify rounded corners

          border: Border.all(width: 1, color: color),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: appstyle(titleFontSize ?? 16, color, FontWeight.w600),
            // Use titleFontSize if provided, otherwise default to 16
          ),
        ),
      ),
    );
  }
}
