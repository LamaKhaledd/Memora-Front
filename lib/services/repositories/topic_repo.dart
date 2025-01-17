import 'package:memora/models/TopicModel.dart';
import 'dart:async';

import 'package:memora/services/contracts/contracts.dart';
import 'package:memora/services/token_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class TopicRepository implements TopicRepositoryContract {
  final baseURL = "${dotenv.env['API_BASE_URL']}/topics";

  @override
  Future<TopicModel> createTopic(String subjectId, String topicName) async {

    final response = await http.post(Uri.parse(baseURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'subject_id': subjectId,
        'topicName': topicName
      })
    );

    final data = jsonDecode(response.body);
    TopicModel createdTopic = TopicModel.fromJson(data);

    return createdTopic;
  }

  @override
  Future<TopicModel> updateTopic(String subjectId, String topicId, String topicName) async {

    final response = await http.put(Uri.parse(baseURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': topicId,
        'subject_id': subjectId,
        'topic_name': topicName
      })
    );

    final data = jsonDecode(response.body);
    TopicModel topicUpdated = TopicModel.fromJson(data);

    return topicUpdated;
  }

  @override
  Future<bool> deleteTopic(String topicId) async {
    String? accessToken = await TokenManager.getAccessToken();

    final response = await http.delete(Uri.parse("$baseURL/$topicId"),
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    );

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }
}
