import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText(
      {super.key, required this.text, required this.style, this.align});

  final String text;
  final TextStyle style;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {

    return Text(
      text,
      maxLines: 1,
      softWrap: false,
      textAlign: align ?? TextAlign.left,
      overflow: TextOverflow.fade,
      style: style,
    );
  }
}
