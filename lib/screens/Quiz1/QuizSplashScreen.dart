import 'package:flutter/material.dart';
import 'package:memora/screens/Quiz1/create_quiz.dart';

import 'TakeQuizScreen.dart';

// Splash screen
class QuizSplashScreen extends StatefulWidget {
  const QuizSplashScreen({super.key});

  @override
  State<QuizSplashScreen> createState() => _QuizSplashScreenState();
}

class _QuizSplashScreenState extends State<QuizSplashScreen> {
  late Size mq; // Declare mq as a variable of type Size

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TakeQuizScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // Body
      body: Stack(
        children: [
          // App logo
          Positioned(
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/quiz.png'),
          ),
          // Google login button
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              'Your chats will be loaded in seconds',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                letterSpacing: .5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
