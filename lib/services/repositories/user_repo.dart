import 'package:memora/models/UserModel.dart';
import 'package:memora/models/ChatUser.dart';
import 'package:memora/services/contracts/contracts.dart';
import 'package:memora/services/token_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository implements UserRepositoryContract {
  final baseURL = "${dotenv.env['API_BASE_URL']}/user";

  @override
  Future<List<ChatUser>> fetchUsers() async {
    final response = await http.get(Uri.parse("$baseURL/all"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => ChatUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<ChatUser> findUserByEmail(String email) async {
    // Use the query parameter style for email
    final response = await http.get(Uri.parse("$baseURL/email?email=$email"));

    if (response.statusCode == 200) {
      // Assuming the API returns a single user object, not a list
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Convert the JSON data to a ChatUser object
      return ChatUser.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user with email $email');
    }
  }

  @override
  Future<ChatUser> updateUser(
      String userId,
      String username,
      String about,
      int age,
      String telephone,
      int numOfCreatedFlashcards,
      int numOfCompletedFlashcards,
      int studyStreak,
      String role, String categories
      ) async {
    final response = await http.put(
      Uri.parse("$baseURL/update"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'username': username,
        'about': about,
        'age': age,
        'telephone': telephone,
        'numOfCreatedFlashcards': numOfCreatedFlashcards,
        'numOfCompletedFlashcards': numOfCompletedFlashcards,
        'studyStreak': studyStreak,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      return ChatUser.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }


  @override
  Future<ChatUser> updateParent(ChatUser user) async {
    final response = await http.put(
      Uri.parse("$baseURL/update-parent"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()), // Convert the ChatUser object to JSON
    );

    if (response.statusCode == 200) {
      return ChatUser.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }


  Future<List<ChatUser>> fetchUsersWithHighestGrades() async {
    final response = await http.get(Uri.parse("$baseURL/highest-flashcards"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => ChatUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users with highest grades');
    }
  }
}
