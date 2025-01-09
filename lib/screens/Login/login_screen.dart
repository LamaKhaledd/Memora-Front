

import 'package:flutter/material.dart';
import 'package:memora/Screens/Login/components/body.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF4F3466), // Set the color here

          child: Icon(Icons.keyboard_backspace_rounded),
          onPressed: (){
            Navigator.of(context).pop(true);
          }
      ),
      body: Body(),
    );
  }
}