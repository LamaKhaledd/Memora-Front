
import 'package:flutter/material.dart';
import 'package:memora/Screens/Signup/components/body.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() {
    return new SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating action button to add a contact (system)
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF4F3466), // Set the color here

          child: Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {
            // Page route
            Navigator.of(context).pop(true);
          }
      ),
      body: Body(),
    );
  }
}