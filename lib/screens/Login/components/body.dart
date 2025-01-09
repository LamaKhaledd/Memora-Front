import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memora/components/rounded_button.dart';
import 'package:memora/components/rounded_input_field.dart';
import 'package:memora/components/rounded_password_field.dart';
import 'package:memora/screens/home_screen.dart';
import 'package:memora/utils/Check.dart';
import 'package:memora/utils/URL.dart';
import '../../parent_screen.dart'; // Adjust the import if needed
import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Repeat the animation
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
                letterSpacing: 2.0,
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
              height: size.height * 0.5,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/girlll.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              myController: emailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            RoundedPasswordField(
              myHintText: "Password",
              myController: passwordController,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            isLoading
                ? RotationTransition(
              turns: _rotationAnimation,
              child: CircularProgressIndicator(color: const Color(0xFF4F3466)),
            )
                : RoundedButton(
              text: "LOGIN",
              press: () {
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter your email!",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey,
                  );
                } else if (!isEmail(email)) {
                  Fluttertoast.showToast(
                    msg: "Please enter a valid email!",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey,
                  );
                } else if (password.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Password cannot be empty!",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey,
                  );
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  login(email, password, context);
                }
              },
              color: const Color(0xFF4F3466),
            ),
          ],
        ),
      ),
    );
  }

  void login(String email, String password, BuildContext context) async {
    String loginURL = baseURL + '/user/login';
    Dio dio = Dio();

    try {
      var response = await dio.post(
        loginURL,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        String responseData = response.data.toString();

        Fluttertoast.showToast(
          msg: responseData,
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey,
        );

        await Future.delayed(Duration(seconds: 2));

        if (responseData.contains("User role: PARENT")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ParentHomePage(parentEmail: email),
            ),
          );
        } else if (responseData.contains("User role: USER")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(title: 'Razan 3amti'),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Login successful, but unknown role!",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server or network error!",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error. Please try again!",
        gravity: ToastGravity.CENTER,
        textColor: Colors.grey,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
