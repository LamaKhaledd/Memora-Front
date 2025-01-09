import 'package:intl/intl.dart';

class FlashcardModel {
  String? id;
  String? userId;
  String? subjectId;
  String? topicId;
  String? question;
  String? answer;
  int difficulty; // 0: easy, 1: medium, 2: hard
  bool lastResponse;
  String? imageUrl;

  // New fields
  DateTime? nextReviewDate;
  int? interval; // in days
  double? easinessFactor;


  // Updated constructor with default values
  FlashcardModel({
    this.id,
    this.userId,
    this.subjectId,
    this.topicId,
    this.question = '', // Default value if null
    this.answer = '', // Default value if null
    this.difficulty = 0, // Default value if null (easy)
    this.lastResponse = false, // Default value if null
    this.imageUrl = 'default_image_url', // Default value if null
    this.nextReviewDate,
    this.interval,
    this.easinessFactor,
  });

  // Format for nextReviewDate
  String? _formatDate(DateTime? date) {
    if (date != null) {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(date);
    }
    return null;
  }

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    // Debugging: Print the raw 'next_review_date'
    print('Raw next_review_date: ${json['nextReviewDate']}');

    DateTime? parsedNextReviewDate;

    // Check if nextReviewDate is a list (representing a timestamp)
    if (json['nextReviewDate'] is List) {
      try {
        // Construct a DateTime object from the list
        List<dynamic> dateList = json['nextReviewDate'];
        if (dateList.length >= 6) {
          parsedNextReviewDate = DateTime(
            dateList[0], // year
            dateList[1], // month
            dateList[2], // day
            dateList[3], // hour
            dateList[4], // minute
            dateList[5], // second
            (dateList.length > 6 ? dateList[6] : 0) ~/ 1000, // handle microseconds if present
          );
          print('Parsed nextReviewDate from list: $parsedNextReviewDate');
        } else {
          print('Error: Date list does not have enough elements');
        }
      } catch (e) {
        print('Error parsing nextReviewDate from list: $e');
      }
    } else if (json['nextReviewDate'] != null) {
      // Attempt to parse if it's a valid DateTime string
      try {
        parsedNextReviewDate = DateTime.parse(json['nextReviewDate']);
        print('Parsed nextReviewDate: $parsedNextReviewDate');
      } catch (e) {
        print('Error parsing nextReviewDate: ${json['nextReviewDate']}');
      }
    }

    return FlashcardModel(
      id: json['id'],
      userId: json['user_id'],
      subjectId: json['subject_id'],
      topicId: json['topic_id'],
      question: json['question'] ?? '', // Default value if null
      answer: json['answer'] ?? '', // Default value if null
      difficulty: json['difficulty'] ?? 0, // Default value if null (easy)
      lastResponse: json['last_response'] ?? false, // Default value if null
      imageUrl: json['image_url'] ?? 'default_image_url', // Default value if null
      nextReviewDate: parsedNextReviewDate,
      interval: json['interval'],
      easinessFactor: json['easiness_factor'],

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'subject_id': subjectId,
    'topic_id': topicId,
    'question': question,
    'answer': answer,
    'difficulty': difficulty,
    'last_response': lastResponse,
    'image_url': imageUrl,
    'next_review_date': _formatDate(nextReviewDate),
    'interval': interval,
    'easiness_factor': easinessFactor,
  };

  FlashcardModel reviewFlashcard(int responseQuality) {
    // Example: Update the easiness factor, interval, and next review date based on response quality
    double newEasinessFactor = easinessFactor ?? 2.5;
    newEasinessFactor = newEasinessFactor + 0.1 * (responseQuality - 2);
    if (newEasinessFactor < 1.3) newEasinessFactor = 1.3; // Limit the easiness factor

    int newInterval = (interval ?? 1) * 2; // Double the interval for simplicity
    DateTime newNextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return FlashcardModel(
      id: id,
      userId: userId,
      subjectId: subjectId,
      topicId: topicId,
      question: question,
      answer: answer,
      difficulty: difficulty,
      lastResponse: lastResponse,
      imageUrl: imageUrl,
      nextReviewDate: newNextReviewDate,
      interval: newInterval,
      easinessFactor: newEasinessFactor,
    );
  }
}
