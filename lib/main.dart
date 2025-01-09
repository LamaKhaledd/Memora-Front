import 'package:memora/providers.dart';
import 'package:memora/screens/HomeSections/Combined.dart';
import 'package:memora/screens/Quiz1/BeginScreen.dart';
import 'package:memora/screens/Quiz1/QuizSplashScreen.dart';
import 'package:memora/screens/about_screen.dart';
import 'package:memora/screens/chat/splash_screen.dart';
import 'package:memora/screens/flashcards_screen.dart';
import 'package:memora/screens/Welcome/welcome_screen.dart';
import 'package:memora/screens/home_screen.dart';
import 'package:memora/screens/parent_screen.dart';
import 'package:memora/screens/Quiz1/create_quiz.dart';

import 'package:memora/screens/statistics_screen.dart';
import 'package:memora/screens/study_history_screen.dart';
import 'package:memora/screens/chat/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memora/screens/study_session_screen.dart';
import 'package:provider/provider.dart';

import 'Screens/Profile/profile_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Memora',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => CombinedPage(),
            '/welcomescreen': (context) => SplashScreen(),
            '/study-session': (context) => StudyHistoryScreen(),
            '/HomeScreen': (context) => HomeScreen(title: 'wewe',),

          },
        );
      },
    );
  }
}