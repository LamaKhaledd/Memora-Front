import 'package:memora/models/FlashcardModel.dart';
class TopicModel {
  String id;
  String subjectId;
  String? imageUrl;
  String topicName;
  List<FlashcardModel> flashcards;

  TopicModel({
    required this.id,
    required this.subjectId,
    required this.topicName,
    this.imageUrl,
    List<FlashcardModel>? flashcards,
  }) : flashcards = flashcards ?? [];

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
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
