
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F3466), // Deep Purple
            Color(0xFF947CAC), // Soft Purple
            Color(0xFFA580A6), // Light Purple
            Color(0xFFCABCD7), // Pale Purple
            Color(0xFFD2C9D4), // Very Light Purple
          ],
          stops: [0.0, 0.3, 0.5, 0.7, 1.0], // Control the gradient spread
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          child,
        ],
      ),
    );
  }
}