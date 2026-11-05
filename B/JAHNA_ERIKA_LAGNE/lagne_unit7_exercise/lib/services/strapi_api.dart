import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pick.dart';

class StrapiApi {
  static const String _baseUrl = 'http://localhost:1337';

  Future<List<Pick>> getPicks() async {
    final uri = Uri.parse('$_baseUrl/api/picks');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to retrieve recommendations.');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> results = data['data'] ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map((json) => Pick.fromJson(json))
        .toList();
  }
}