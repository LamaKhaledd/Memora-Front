import 'package:flutter/material.dart';
import 'package:memora/Screens/Login/login_screen.dart';
import 'package:memora/Screens/Signup/signup_screen.dart';
import 'package:memora/components/rounded_button.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Welcome Text
            SizedBox(height: size.height * 0.05),
            Text(
              "WELCOME TO MEMORA",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
                letterSpacing: 2.0,
                // Added spacing for style
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ], // Added shadow for better text visibility
              ),
            ),

            // Space for the big image (leave a defined space)
            SizedBox(height: 0.05),

            // Big Image container
            Container(
              width: size.width * 1.1, // Adjust the width for the image.
              height: size.height * 0.5, // Defined height for the image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/group2.png"),
                  // Add your big image here
                  fit: BoxFit
                      .contain, // Ensures the image maintains its aspect ratio
                ),
                borderRadius: BorderRadius.circular(
                    20), // Optional: Adds rounded corners to the image
              ),
            ),

            SizedBox(height: size.height * 0.05),

            // Login Button
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              color: Color(0xFF4F3466), // Deep Purple
              textColor: Colors.white, // White text for better contrast
            ),
            SizedBox(height: size.height * 0.02),

            // Sign Up Button
            RoundedButton(
              text: "SIGN UP",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
              color: Color(0xFF947CAC), // Soft Purple
              textColor: Colors.white, // White text for better contrast
            ),
          ],
        ),
      ),
    );
  }
}