import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memora/models/MessageModel.dart';


class MessageRepository {
  final baseURL = "${dotenv.env['API_BASE_URL']}/messages";

  // Fetch all messages
  Future<List<MessageModel>> fetchMessages() async {
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // Send a message
  Future<MessageModel> sendMessage(MessageModel message) async {
    final response = await http.post(
      Uri.parse(baseURL),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 201) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }

  // Update message read status
  Future<MessageModel> updateMessageReadStatus(String messageId, String readStatus) async {
    final response = await http.put(
      Uri.parse("$baseURL/$messageId"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'read': readStatus}),
    );

    if (response.statusCode == 200) {
      return MessageModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update message status');
    }
  }
}
