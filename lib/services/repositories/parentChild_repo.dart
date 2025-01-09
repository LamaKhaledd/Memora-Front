import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParentChildRelationshipRepository {
  final baseURL = "${dotenv.env['API_BASE_URL']}/relationship";

  /// Fetch all children for a given parent ID.
  Future<List<dynamic>> getAllChildrenByParentId(String parentId) async {
    final response = await http.get(Uri.parse("$baseURL/all-children/$parentId"),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to fetch children: ${response.statusCode}");
    }
  }

  /// Fetch the number of children for a given parent ID.
  Future<int> getNumberOfChildrenByParentId(String parentId) async {
    final response = await http.get(Uri.parse("$baseURL/children-count/$parentId"),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      return json.decode(response.body) as int;
    } else {
      throw Exception("Failed to fetch children count: ${response.statusCode}");
    }
  }

  /// Fetch all parent IDs.
  Future<List<String>> getAllParentIds() async {
    final response = await http.get(Uri.parse("$baseURL/all-parents"),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } else {
      throw Exception("Failed to fetch parent IDs: ${response.statusCode}");
    }
  }
}
