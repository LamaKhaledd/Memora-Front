import '../models/ChatUser.dart';

class UserManager {
  static String userId = '';

  static void setUserDetails({required String id}) {
    userId = id;
  }

  static ChatUser model = ChatUser(
    userId: "",
    username: "",
    email: "",
    password: "",
    about: "",
    image: "",
    location: "",
    createdAt: "",
    lastActive: "",
    isOnline: false,
    telephone: "",
    favouriteCategories: "",
    age: 0,
    numOfCreatedFlashcards: 0,
    numOfCompletedFlashcards: 0,
    studyStreak: 0,
    isEnabled: false,
    role: "",
    flashcardsCount: 0,
  );

  static void setChat({required ChatUser models}) {
    model = models;
  }

  static String jobId = '';

  static void setJobDetails({required String id}) {
    jobId = id;
  }

  static String description = '';

  static void setDescription({required String description1}) {
    description = description1;
  }

  static String requirements = '';

  static void setRequirements({required String requirements1}) {
    requirements = requirements1;
  }

  static String adminId = '';

  static void setAdminId({required String id}) {
    adminId = id;
  }

  static String back = '';

  static void setBack({required String id}) {
    back = id;
  }

  static String image = '';

  static void setImage({required String image1}) {
    image = image1;
  }

  static List<String> questions = [];
  static List<String> answers = [];

  static void setQuestions({required String question1}) {
    questions.add(question1);
  }

  static List<String> option1 = [];

  static void setOption1({required String option}) {
    option1.add(option);
  }

  static List<String> option2 = [];

  static void setOption2({required String option}) {
    option2.add(option);
  }

  static List<String> option3 = [];

  static void setOption3({required String option}) {
    option3.add(option);
  }

  static List<String> option4 = [];

  static void setOption4({required String option}) {
    option4.add(option);
  }
}
