import 'package:flutter/material.dart';
import '../../main.dart';
import 'home_screen.dart';

// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size mq; // Declare mq as a variable of type Size

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChatHomeScreen()),
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
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('mem.jpeg'),
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
