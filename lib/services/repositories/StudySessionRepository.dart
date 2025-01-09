import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memora/models/StudySessionModel.dart';

class StudySessionRepository {
  final String baseURL = "${dotenv.env['API_BASE_URL']}/study-sessions";

  // Fetch all study sessions
  Future<List<StudySessionModel>> fetchAllStudySessions() async {
    final response = await http.get(Uri.parse("$baseURL/all"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => StudySessionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load study sessions');
    }
  }

  Future<StudySessionModel> createStudySession(StudySessionModel session) async {
    // Print the serialized StudySessionModel before sending the request
    print('Creating study session:');
    print(json.encode(session.toJson())); // Convert the session to JSON and print it

    final response = await http.post(
      Uri.parse("$baseURL/create"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(session.toJson()),
    );

    if (response.statusCode == 200) {
      print('Study session created successfully:');
      print(response.body); // Print the response body
      return StudySessionModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to create study session. Response:');
      print(response.body); // Print the error response body
      throw Exception('Failed to create study session');
    }
  }


  // Fetch a single study session by ID (optional if needed later)
  Future<StudySessionModel> fetchStudySessionById(String sessionId) async {
    final response = await http.get(Uri.parse("$baseURL/$sessionId"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return StudySessionModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load study session with ID $sessionId');
    }
  }

  // Update a study session (optional if needed later)
  Future<StudySessionModel> updateStudySession(StudySessionModel session) async {
    final response = await http.put(
      Uri.parse("$baseURL/update/${session.subjectId}"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(session.toJson()),
    );
    if (response.statusCode == 200) {
      return StudySessionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update study session');
    }
  }

  // Delete a study session by its ID (optional if needed later)
  Future<void> deleteStudySession(String sessionId) async {
    final response = await http.delete(Uri.parse("$baseURL/delete/$sessionId"));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete study session');
    }
  }
}
