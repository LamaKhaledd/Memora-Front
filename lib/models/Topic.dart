import 'package:memora/models/FlashcardModel.dart';

class Topic {
  final String id;
  String subjectId;
  final String imageUrl;
  final String topicName;
  List<FlashcardModel> flashcards;

  Topic({
    required this.id,
    required this.subjectId,
    required this.imageUrl,
    required this.topicName,
    List<FlashcardModel>? flashcards,
  }): flashcards = flashcards ?? [];

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      subjectId: json['subject_id'],
      imageUrl: json['imageUrl'],
      topicName: json['topicName'],
      flashcards: (json['flashcards'] as List<dynamic>?)
          ?.map((flashcardJson) => FlashcardModel.fromJson(flashcardJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'imageUrl': imageUrl,
    'topicName': topicName,
    'flashcards': flashcards.map((flashcard) => flashcard.toJson()).toList(),
  };

}