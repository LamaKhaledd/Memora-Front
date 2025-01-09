import 'dart:io';
import 'package:memora/models/FlashcardModel.dart';
import 'dart:async';
import 'package:memora/services/contracts/contracts.dart';
import 'package:memora/services/token_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlashcardRepository implements FlashcardRepositoryContract {
  final baseURL = "${dotenv.env['API_BASE_URL']}/flashcard";

  // Existing method for updating response quality
  @override
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard, int responseQuality) async {
    try {
      print("Updated response quality: $responseQuality");

      final url = Uri.parse("$baseURL/review/${flashcard.id}?responseQuality=$responseQuality");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        FlashcardModel updatedFlashcard = FlashcardModel.fromJson(data);
        return updatedFlashcard;
      } else {
        print('Error on review flashcard, Status Code: ${response.statusCode}');
        return flashcard; // Return the original if failed
      }
    } catch (e) {
      print('Error on review flashcard: $e');
      return flashcard; // Return the original if error occurs
    }
  }

  // New function to update the flashcard
  @override
  Future<FlashcardModel?> updateFlashcardById(FlashcardModel updatedFlashcard) async {
    String? flashcardId=updatedFlashcard.id;
    try {
      print(updatedFlashcard.subjectId);
      print(updatedFlashcard.topicId);

      final url = Uri.parse("$baseURL/$flashcardId");

      // Prepare the updated flashcard data
      final requestBody = {
        'question': updatedFlashcard.question,
        'answer': updatedFlashcard.answer,
        'difficulty': updatedFlashcard.difficulty,
        'imageUrl': updatedFlashcard.imageUrl
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successfully updated, return the updated flashcard
        final data = jsonDecode(response.body);
        return FlashcardModel.fromJson(data);
      } else {
        // Handle error, print status code and return null
        print('Error updating flashcard, Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Catch and handle any error during the request
      print('Error updating flashcard: $e');
      return null;
    }
  }

  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    try {
      final response = await http.delete(Uri.parse("$baseURL/$flashcardId"));
      if (response.statusCode != 200) {
        print('Error on delete flashcard, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error on delete flashcard: $e');
    }
  }

  @override
  Future<List<FlashcardModel>> uploadFile(
      File file, int quantity, int difficulty, String subjectId, String topicId) async {
    String? accessToken = await TokenManager.getAccessToken();


    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse("$baseURL/generate?quantity=$quantity&difficulty=$difficulty&subject_id=$subjectId&topic_id=$topicId")
      );

      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: file.path.split('/').last
      );

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken'
      });

      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse.containsKey('flashcards')) {
          List<dynamic> flashcardsJson = jsonResponse['flashcards'];
          return flashcardsJson
              .map((json) => FlashcardModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to upload file: ${response.reasonPhrase}');
      }

    } catch (e) {
      print('Error on create flashcard: $e');
      return [];
    }
  }


  @override
  Future<List<FlashcardModel>> getDueFlashcards(String userId) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/due/$userId"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FlashcardModel.fromJson(json)).toList();
      } else {
        print('Error on get due flashcards, Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error on get due flashcards: $e');
      return [];
    }
  }

  @override
  Future<FlashcardModel?> createFlashcard(FlashcardModel flashcard, String subjectId, String topicId) async {
    try {
      final requestBody = {
        'question': flashcard.question,
        'answer': flashcard.answer,
        'difficulty': flashcard.difficulty,
        'subjectId': subjectId,
        'topicId': topicId,
        'nextReviewDate': flashcard.nextReviewDate?.toIso8601String(),
        'interval': flashcard.interval,
        'easinessFactor': flashcard.easinessFactor,
      };

      final response = await http.post(
        Uri.parse(baseURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return FlashcardModel.fromJson(data);
      } else {
        print('Error on create flashcard, Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error on create flashcard: $e');
      return null;
    }
  }
}
