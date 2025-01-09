class BookModel {
  String? id;
  String? userId;
  String? title;
  String? author;
  String? imageUrl;
  String? ageRange; // Age suitability for the book
  String? downloadLink; // Link to download the book
  String? description; // Short description of the book

  BookModel({
    this.id,
    this.userId,
    this.title,
    this.author,
    this.imageUrl,
    this.ageRange,
    this.downloadLink,
    this.description,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['bookId'],
      userId: json['userId'],
      title: json['title'],
      author: json['author'],
      imageUrl: json['imageUrl'],
      ageRange: json['ageRange'],
      downloadLink: json['downloadLink'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'bookId': id,
    'userId': userId,
    'title': title,
    'author': author,
    'imageUrl': imageUrl,
    'ageRange': ageRange,
    'downloadLink': downloadLink,
    'description': description,
  };
}
