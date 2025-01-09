import 'dart:io';

import 'package:memora/models/AuthTokenModel.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:memora/models/SubjectModel.dart';
import 'package:memora/models/TopicModel.dart';
import 'package:memora/models/UserModel.dart';
import 'package:memora/models/MessageModel.dart';
import '../../models/ChatUser.dart';

abstract class AuthRepositoryContract {
  Future<AuthTokenModel?> authenticate(String accessToken);
  Future<UserModel?> getStoredUser();
}

abstract class UserRepositoryContract {
  Future<List<ChatUser>> fetchUsers();
  Future<ChatUser> updateUser(
      String userId,
      String username,
      String about,
      int age,
      String telephone,
      int numOfCreatedFlashcards,
      int numOfCompletedFlashcards,
      int studyStreak,
      String role,
      String categories
      );
}

abstract class PreferencesRepositoryContract {
  Future<void> setAppPreferences(String theme, String language);
  Future<Map<String, String?>> getAppPreferences();
  Future<void> clearUserPrefs();
}

abstract class SubjectRepositoryContract {
  Future<List<SubjectModel>?> fetchSubjects(int offset, int limit, String searchTerm);
  Future<SubjectModel> createSubject(SubjectModel subject);
  Future<bool> deleteSubject(String subjectId);
  Future<SubjectModel?> updateSubject(String id, String name);
}

abstract class TopicRepositoryContract {
  Future<TopicModel> createTopic(String subjectId, String topicName);
  Future<TopicModel> updateTopic(String subjectId, String topicId, String topicName);
  Future<bool> deleteTopic(String topicId);
}


abstract class MessageRepositoryContract {
  Future<List<MessageModel>> fetchMessages();
}

abstract class FlashcardRepositoryContract {
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard,int responseQuality);
  Future<void> deleteFlashcard(String flashcardId);
  Future<List<FlashcardModel>> uploadFile(
      File file, int quantity, int difficulty, String subjectId, String topicId);
  Future<FlashcardModel?> createFlashcard(FlashcardModel flashcard,String subjectId, String topicId);
}
