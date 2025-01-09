import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memora/constants/app_constants.dart';
import 'package:memora/components/common/app_style.dart';
import 'package:memora/components/common/height_spacer.dart';
import 'package:memora/components/common/reusable_text.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: width,
          height: height,
      color: Color(kDarkBlue.value),
      child: Column(
        children: [
         const  HeightSpacer(size: 100,),

          Image.asset("assets/images/page-2.png"),

         const  HeightSpacer(size: 120),
         Column(
          children: [
            ReusableText(text:"Find Your project management", style: appstyle(20, Color(kDark.value), FontWeight.w500)),
           const  HeightSpacer(size: 10),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Text("Optimize project management with our app.",textAlign: TextAlign.center, style: appstyle(14, Color(kDark.value), FontWeight.normal)),
            )
          ],
         )


        ],
      ),
    ));
  }
}
/*
Optimize project management with our app.
*/