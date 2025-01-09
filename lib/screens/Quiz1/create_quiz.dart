import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:memora/models/QuizModel.dart'; // Assume this is your Quiz model

class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({super.key});

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _questions = []; // To store questions, options, and answers
  bool _isLoading = false;

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'option1': '',
        'option2': '',
        'option3': '',
        'option4': '',
        'correctAnswer': '',
      });
    });
  }

  void _createQuiz() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Map the questions to your QuizModel structure
      List<QuizModel> quizList = _questions.map((q) {
        return QuizModel(
          id: '5',
          question: q['question']!,
          options: [
            q['option1']!,
            q['option2']!,
            q['option3']!,
            q['option4']!
          ],
          correctAnswer: q['correctAnswer']!,
        );
      }).toList();

      // Replace this with API call to save the quiz
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quiz created successfully!')));

        // Reset form or perform any other action
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Create Quiz",
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Instructions text above the questions
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Please create your quiz by filling in the questions and options below. You can add as many questions as needed!",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              // Display the dynamic list of questions
              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return QuestionForm(
                      questionData: _questions[index],
                      onChanged: (key, value) {
                        setState(() {
                          _questions[index][key] = value;
                        });
                      },
                      onAnswerSelected: (selectedAnswer) {
                        setState(() {
                          _questions[index]['correctAnswer'] = selectedAnswer;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Add a new question button
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: Icon(Icons.add, size: 18),
                label: Text('Add Question'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                onPressed: _createQuiz,
                icon: Icon(Icons.check_circle_outline, size: 18),
                label: Text('Create Quiz'),
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
      ),
    );
  }
}

class QuestionForm extends StatelessWidget {
  final Map<String, String> questionData;
  final Function(String, String) onChanged;
  final Function(String) onAnswerSelected;

  const QuestionForm({
    super.key,
    required this.questionData,
    required this.onChanged,
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
            TextFormField(
              initialValue: questionData['question'],
              decoration: InputDecoration(
                labelText: 'Question',
                icon: Icon(Icons.question_answer, color: Colors.blue),
              ),
              onChanged: (value) {
                onChanged('question', value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            SizedBox(height: 8),  // Adding small space between question and options
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: questionData['option1'],
                    decoration: InputDecoration(
                      labelText: 'Option 1',
                      icon: Icon(Icons.radio_button_checked, color: Colors.blue),
                    ),
                    onChanged: (value) {
                      onChanged('option1', value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  ),
                ),
                Radio<String>(
                  value: 'option1',
                  groupValue: questionData['correctAnswer'],
                  onChanged: (value) {
                    onAnswerSelected(value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: questionData['option2'],
                    decoration: InputDecoration(
                      labelText: 'Option 2',
                      icon: Icon(Icons.radio_button_checked, color: Colors.blue),
                    ),
                    onChanged: (value) {
                      onChanged('option2', value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  ),
                ),
                Radio<String>(
                  value: 'option2',
                  groupValue: questionData['correctAnswer'],
                  onChanged: (value) {
                    onAnswerSelected(value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: questionData['option3'],
                    decoration: InputDecoration(
                      labelText: 'Option 3',
                      icon: Icon(Icons.radio_button_checked, color: Colors.blue),
                    ),
                    onChanged: (value) {
                      onChanged('option3', value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  ),
                ),
                Radio<String>(
                  value: 'option3',
                  groupValue: questionData['correctAnswer'],
                  onChanged: (value) {
                    onAnswerSelected(value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: questionData['option4'],
                    decoration: InputDecoration(
                      labelText: 'Option 4',
                      icon: Icon(Icons.radio_button_checked, color: Colors.blue),
                    ),
                    onChanged: (value) {
                      onChanged('option4', value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  ),
                ),
                Radio<String>(
                  value: 'option4',
                  groupValue: questionData['correctAnswer'],
                  onChanged: (value) {
                    onAnswerSelected(value!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
