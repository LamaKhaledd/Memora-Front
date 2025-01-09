import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memora/models/BookModel.dart';

class BookRepository {
  final String baseURL = "${dotenv.env['API_BASE_URL']}/books";

  // Fetch all books
  Future<List<BookModel>> fetchBooks() async {
    final response = await http.get(Uri.parse("$baseURL/all"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  // Get a book by its ID
  Future<BookModel> fetchBookById(String bookId) async {
    final response = await http.get(Uri.parse("$baseURL/$bookId"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return BookModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load book with ID $bookId');
    }
  }

  // Save or update a book
  Future<BookModel> saveBook(BookModel book) async {
    final response = await http.post(
      Uri.parse("$baseURL/save"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(book.toJson()),
    );
    if (response.statusCode == 200) {
      return BookModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save or update book');
    }
  }

  // Delete a book by its ID
  Future<void> deleteBook(String bookId) async {
    final response = await http.delete(Uri.parse("$baseURL/delete/$bookId"));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }
}
