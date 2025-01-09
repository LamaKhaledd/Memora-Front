import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/constants/app_constants.dart';
import 'package:memora/components/common/app_style.dart';
import 'package:memora/components/common/reusable_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key,
      this.text,
      required this.child,
      this.actions,
      this.titleFontSize, this.color});

  final String? text;
  final Widget child;
  final List<Widget>? actions;
  final double? titleFontSize;
  final Color? color;
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      iconTheme: const IconThemeData(),
      backgroundColor:  color??Color(kLight.value),
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 70.w,
      leading: child,
      actions: actions,
      centerTitle: true,
      title: ReusableText(
        text: text ?? "",
        style:
            appstyle(titleFontSize ?? 16, Color(kDark.value), FontWeight.w600),
      ),
    );
  }
}
