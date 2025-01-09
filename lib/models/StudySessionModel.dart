import 'package:memora/models/FlashcardModel.dart';

class StudySessionModel {
  String subjectId;
  String topicName;
  String topicId;
  int correctAnswerCount;
  int incorrectAnswerCount;
  int totalQuestions;
  String totalTimeSpent;
  int easyQuestionCount;
  int mediumQuestionCount;
  int hardQuestionCount;
  List<FlashcardModel> easyQuestions;
  List<FlashcardModel> mediumQuestions;
  List<FlashcardModel> hardQuestions;

  StudySessionModel({
    required this.subjectId,
    required this.topicName,
    required this.topicId,
    required this.correctAnswerCount,
    required this.incorrectAnswerCount,
    required this.totalQuestions,
    required this.totalTimeSpent,
    required this.easyQuestionCount,
    required this.mediumQuestionCount,
    required this.hardQuestionCount,
    required this.easyQuestions,
    required this.mediumQuestions,
    required this.hardQuestions,
  });

  // Factory method to convert JSON to StudySessionModel
  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      subjectId: json['subjectId'],
      topicName: json['topicName'],
      topicId: json['topicId'],
      correctAnswerCount: json['correctAnswerCount'],
      incorrectAnswerCount: json['incorrectAnswerCount'],
      totalQuestions: json['totalQuestions'],
      totalTimeSpent: json['totalTimeSpent'],
      easyQuestionCount: json['easyQuestionCount'],
      mediumQuestionCount: json['mediumQuestionCount'],
      hardQuestionCount: json['hardQuestionCount'],
      easyQuestions: (json['easyQuestions'] is List)
          ? (json['easyQuestions'] as List)
          .map((e) => FlashcardModel.fromJson(e))
          .toList()
          : [],
      mediumQuestions: (json['mediumQuestions'] is List)
          ? (json['mediumQuestions'] as List)
          .map((e) => FlashcardModel.fromJson(e))
          .toList()
          : [],
      hardQuestions: (json['hardQuestions'] is List)
          ? (json['hardQuestions'] as List)
          .map((e) => FlashcardModel.fromJson(e))
          .toList()
          : [],
    );
  }

  // Convert StudySessionModel to JSON
  Map<String, dynamic> toJson() => {
    'subjectId': subjectId,
    'topicId': topicId,
    'topicName': topicName,
    'correctAnswerCount': correctAnswerCount,
    'incorrectAnswerCount': incorrectAnswerCount,
    'totalQuestions': totalQuestions,
    'totalTimeSpent': totalTimeSpent,
    'easyQuestionCount': easyQuestionCount,
    'mediumQuestionCount': mediumQuestionCount,
    'hardQuestionCount': hardQuestionCount,
    'easyQuestions': easyQuestions.map((e) => e.toJson()).toList(),
    'mediumQuestions': mediumQuestions.map((e) => e.toJson()).toList(),
    'hardQuestions': hardQuestions.map((e) => e.toJson()).toList(),
  };
}
