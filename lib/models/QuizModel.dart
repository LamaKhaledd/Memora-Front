class QuizModel {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> options;

  QuizModel({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  // Factory method to create QuizModel from JSON response
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'] ?? '',
      question: json['question'],
      correctAnswer: json['correctAnswer'],
      options: List<String>.from(json['options']),
    );
  }

  // Method to convert the QuizModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }
}
