

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memora/Screens/Login/login_screen.dart';
import 'package:memora/Screens/Signup/components/background.dart';
import 'package:memora/Screens/Signup/components/or_divider.dart';
import 'package:memora/Screens/Signup/components/social_icon.dart';
import 'package:memora/components/already_have_an_account_acheck.dart';
import 'package:memora/components/rounded_button.dart';
import 'package:memora/components/rounded_input_field.dart';
import 'package:memora/components/rounded_password_field.dart';
import 'package:memora/utils/Check.dart';
import 'package:memora/utils/URL.dart';
import 'package:memora/utils/colorUtil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

class Body extends StatelessWidget {
  String email = "";
  String username = "";
  String password = "";
  TextEditingController makeSureControl = new TextEditingController();
  String token = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      key: UniqueKey(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Text(
              "SIGNUP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.05),
            Container(
              height: size.height * 0.5, // Adjust height as needed
              width: size.width * 0.6,   // Adjust width for proper aspect ratio
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/girl.png"), // Path to your image
                  fit: BoxFit.contain, // Ensure the image maintains its aspect ratio
                ),
              ),
            ),

            RoundedInputField(
              hintText: "Sign Email",
              icon: Icons.alternate_email,
              onChanged: (value) {
                email = value;
              },
              myController: TextEditingController(),
            ),
            RoundedInputField(
              hintText: "Username",
              icon: Icons.emoji_people,
              onChanged: (value) {
                username = value;
              },
              myController: TextEditingController(),
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
              myHintText: "Password",
              myController: TextEditingController(),
            ),
            RoundedPasswordField(
              onChanged: (value) {},
              myController: makeSureControl,
              myHintText: "Make sure",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 35.0)),
                Expanded(
                  child: RoundedInputField(
                    hintText: "Token",
                    icon: Icons.code,
                    onChanged: (value) {
                      token = value;
                    },
                    myController: TextEditingController(),
                  ),
                ),
                Expanded(
                  child: RoundedButton(
                    text: "Send",
                    color: Color(0xFF4F3466), // Deep Purple
                    press: () {
                      // Validation
                      print("Below is signup validation");
                      if (!isEmail(email)) {
                        Fluttertoast.showToast(
                            msg: "Please ensure the email is correct!",
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.grey);
                      }
                      else if (!isUsername(username)) {
                        Fluttertoast.showToast(
                            msg: "Username must be 5-10 characters long, start with a letter, and can contain letters, numbers, and _ (at least one uppercase letter)",
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.grey);
                      }
                      else if (!isPassword(password)) {
                        Fluttertoast.showToast(
                            msg: "Password must be 6-12 characters long and can only contain letters, numbers, and _",
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.grey);
                      }
                      else if (!(makeSureControl.text == password)) {
                        makeSureControl.clear();
                        Fluttertoast.showToast(
                            msg: "Please confirm that the second input matches the first one",
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.grey);
                      }
                      else {
                        print("Trying to send");
                        send();
                      }
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 40.0)),
              ],
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                // Register
                SignUp(context);
              },
              color: Color(0xFF947CAC), // Soft Purple
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
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
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Register
  void SignUp(BuildContext context) async {
    String loginURL = baseURL + '/user/register';
    Dio dio = new Dio();

    var response = await dio.post(
        loginURL + "?token=" + token,
        data: {'email': email, 'password': password, "username": username}
    );

    print('Response ${response.statusCode}');
    print(response.data);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: response.data,
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);

      if (response.data == "sucess") {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
    else {
      showToast("Server or network error!");
    }
  }

  // Send verification code
  void send() async {
    String sendURL = baseURL + "/user/send";
    Dio dio = new Dio();
    print("Username: " + username);
    print("Username: " + email);
    print("Username: " + password);
    var response = await dio.post(
        sendURL,
        data: {'email': email, 'password': password, "username": username}
    );
    print('Response ${response.statusCode}');
    print(response.data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: response.data,
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
      token = response.data.toString();
    }
    else {
      showToast("Server or network error!");
    }
  }
}