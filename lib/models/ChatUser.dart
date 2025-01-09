class ChatUser {
  ChatUser({
    required this.userId,
    required this.email,
    required this.password,
    required this.about,
    required this.image,
    required this.location,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.telephone,
    required this.favouriteCategories,
    required this.age,
    required this.numOfCreatedFlashcards,
    required this.numOfCompletedFlashcards,
    required this.studyStreak,
    required this.username,
    required this.isEnabled,
    required this.role,
    required this.flashcardsCount,

  });

  late final String userId;
  late final String email;
  late final String password;
  late final String about;
  late final String image;
  late final String location;
  late final String createdAt;
  late final String lastActive;
  late final bool isOnline;
  late final String telephone;
  late final String favouriteCategories;
  late final int age;
  late final int numOfCreatedFlashcards;
  late final int numOfCompletedFlashcards;
  late final int studyStreak;
  late final int flashcardsCount;
  late final String username;
  late final bool isEnabled;
  late final String role;

  ChatUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    about = json['about'] ?? '';
    image = json['image'] ?? '';
    location = json['location'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['isOnline'] ?? false;
    telephone = json['telephone'] ?? '';
    favouriteCategories = json['favouriteCategories'] ?? '';
    age = json['age'] ?? 0;
    numOfCreatedFlashcards = json['numOfCreatedFlashcards'] ?? 0;
    numOfCompletedFlashcards = json['numOfCompletedFlashcards'] ?? 0;
    flashcardsCount=json['flashcardsCount']?? 0;
    studyStreak = json['studyStreak'] ?? 0;
    username = json['username'] ?? '';
    isEnabled = json['isEnabled'] ?? false;
    role = json['role'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['password'] = password;
    data['about'] = about;
    data['image'] = image;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['isOnline'] = isOnline;
    data['telephone'] = telephone;
    data['favouriteCategories'] = favouriteCategories;
    data['age'] = age;
    data['flashcardsCount']=flashcardsCount;
    data['numOfCreatedFlashcards'] = numOfCreatedFlashcards;
    data['numOfCompletedFlashcards'] = numOfCompletedFlashcards;
    data['studyStreak'] = studyStreak;
    data['username'] = username;
    data['isEnabled'] = isEnabled;
    data['role'] = role;
    return data;
  }
}
