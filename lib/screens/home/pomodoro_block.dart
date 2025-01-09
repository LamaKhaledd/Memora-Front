import 'dart:async';
import 'package:flutter/material.dart';
import '../Welcome/welcome_screen.dart';

class PomodoroCard extends StatefulWidget {
  @override
  _PomodoroCardState createState() => _PomodoroCardState();
}

class _PomodoroCardState extends State<PomodoroCard> {
  bool isPomodoroActive = false;
  bool isBreakTime = false; // Determines if it's break time or Pomodoro time
  int completedPomodoros = 0; // Track how many Pomodoros have been completed

  Duration pomodoroDuration = Duration(minutes: 1); // Initial Pomodoro duration
  Duration remainingTime = Duration(minutes: 1); // Remaining time
  Timer? timer; // Timer object

  // Function to start or stop the timer
  void _togglePomodoro() {
    setState(() {
      if (isPomodoroActive) {
        // Stop the timer
        timer?.cancel();
        isPomodoroActive = false;
        remainingTime = pomodoroDuration; // Reset the timer
      } else {
        // Start the timer
        isPomodoroActive = true;
        timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (remainingTime.inSeconds > 0) {
            setState(() {
              remainingTime = remainingTime - Duration(seconds: 1);
            });
          } else {
            timer.cancel();
            setState(() {
              isPomodoroActive = false;
              isBreakTime = true;
              completedPomodoros++;
              remainingTime = Duration(minutes: 5); // Start a break
            });
          }
        });
      }
    });
  }

  // Format the time for display
  String _formatTime(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Pomodoro Timer",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color ?? Colors.black,
              ),
            ),
          ),
        ),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.timer,
                    size: 120,
                    color: Color(0xFF4F3466),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Stay Focused with Pomodoro",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color ?? Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Break your work into focused intervals, with short breaks in between.",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color ?? Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isPomodoroActive
                      ? "Time Remaining: ${_formatTime(remainingTime)}"
                      : isBreakTime
                      ? "Break Time: ${_formatTime(remainingTime)}"
                      : "Ready to Start",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA580A6),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _togglePomodoro,
                      child: Text(
                        isPomodoroActive ? "Stop" : "Start",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPomodoroActive
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        );
                      },
                      child: Text(
                        "Go to Pomodoro Home",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA580A6),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Pomodoros Completed: $completedPomodoros",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Tip: Work in short bursts of focus to stay productive!",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }
}
