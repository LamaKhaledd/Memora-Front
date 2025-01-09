
import 'package:memora/models/TopicModel.dart';
import 'package:memora/models/Topic.dart';
class SubjectModel {
  String? id;
  String? subjectName;
  String? userId;
  String? imageUrl;
  List<TopicModel>? topics = [];

  SubjectModel({
    this.id,
    this.subjectName,
    this.userId,
    this.imageUrl,
    this.topics,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    List<TopicModel> topics = [];
    if (json['topics'] != null) {
      json['topics'].forEach((topicJson) {
        topics.add(TopicModel.fromJson(topicJson));
      });
    }
    

    return SubjectModel(
      id: json['id'],
      subjectName: json['subjectName'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      topics: topics
    );

  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'subjectName': subjectName,
    'userId': userId,
    'imageUrl': imageUrl,
    'topics': topics?.map((topic) => topic.toJson()).toList(),
  };
}