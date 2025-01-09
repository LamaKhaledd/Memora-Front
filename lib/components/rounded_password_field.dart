import 'package:flutter/material.dart';
import 'package:memora/components/text_field_container.dart';
import 'package:memora/utils/colorUtil.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String myHintText;
  final TextEditingController myController;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.myHintText,
    required this.myController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: myController,
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: myHintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          // suffixIcon: Icon(
          //   Icons.visibility,
          //   color: kPrimaryColor,
          // ),

          border: InputBorder.none,
        ),
      ),
    );
  }
}
