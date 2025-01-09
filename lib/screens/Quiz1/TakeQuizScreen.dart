import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memora/models/QuizModel.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizModel> quiz = [
    QuizModel(
      id: '1',
      question: 'What is the capital of France?',
      options: ['Paris', 'London', 'Rome', 'Berlin'],
      correctAnswer: 'Paris',
    ),
    QuizModel(
      id: '2',
      question: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
    ),
    QuizModel(
      id: '3',
      question: 'Who wrote "Hamlet"?',
      options: ['Shakespeare', 'Dickens', 'Austen', 'Tolkien'],
      correctAnswer: 'Shakespeare',
    ),
  ];

  List<Map<String, String>> _userAnswers = [];
  int _currentQuestionIndex = 0;
  int _elapsedTime = 0; // Timer starts from 0
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.generate(
      quiz.length,
          (index) => {'questionId': quiz[index].id, 'answer': ''},
    );

    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void _onAnswerSelected(String value) {
    setState(() {
      _userAnswers[_currentQuestionIndex]['answer'] = value;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < quiz.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  void _submitQuiz() {
    int score = 0;

    for (int i = 0; i < quiz.length; i++) {
      if (_userAnswers[i]['answer'] == quiz[i].correctAnswer) {
        score++;
      }
    }

    // Show score to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You scored $score/${quiz.length}'),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _elapsedTime ~/ 60;
    int seconds = _elapsedTime % 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("Take Quiz"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Timer display
            Text(
              "$minutes:${seconds.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display the current question
            QuestionWidget(
              questionData: quiz[_currentQuestionIndex],
              userAnswer: _userAnswers[_currentQuestionIndex]['answer']!,
              onAnswerSelected: _onAnswerSelected,
            ),
            SizedBox(height: 20),
            // Next button
            ElevatedButton(
              onPressed: _currentQuestionIndex < quiz.length - 1
                  ? _nextQuestion
                  : _submitQuiz,
              child: Text(_currentQuestionIndex < quiz.length - 1
                  ? 'Next Question'
                  : 'Submit Quiz'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final QuizModel questionData;
  final String userAnswer;
  final Function(String) onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.questionData,
    required this.userAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              questionData.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...List.generate(
              questionData.options.length,
                  (index) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        questionData.options[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Radio<String>(
                      value: questionData.options[index],
                      groupValue: userAnswer,
                      onChanged: (value) {
                        onAnswerSelected(value!);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
