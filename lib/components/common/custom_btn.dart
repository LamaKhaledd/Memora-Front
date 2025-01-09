import 'package:flutter/material.dart';
import 'package:memora/constants/app_constants.dart';
import 'package:memora/components/common/app_style.dart';
import 'package:memora/components/common/reusable_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.titleFontSize,
    this.width,
    this.height, this.color, this.style, this.alig, this.sizeof,
  }) : super(key: key);

  final String text;
  final void Function()? onTap;
  final double? titleFontSize;
  final double? width;
  final double? height;
  final Color? color;
    final TextStyle? style;
     final Alignment? alig;
final double? sizeof;
  @override
  Widget build(BuildContext context) {
  
    return GestureDetector(
      
      onTap: onTap,
      child: Container(
       
        width: width,
        height: height ?? MediaQuery.of(context).size.height * 0.065,
        decoration: BoxDecoration(
          
          color: color??Color(kOrange.value)  ,
          borderRadius: BorderRadius.circular(sizeof??15),
        ),
        child: Center(

          child: ReusableText(
            text: text,
            style:  style?? appstyle(
              titleFontSize ?? 16,
              Color(kLight.value),
              FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
