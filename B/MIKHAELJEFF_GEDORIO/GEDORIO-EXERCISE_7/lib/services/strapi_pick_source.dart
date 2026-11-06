import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';

class StrapiPickSource implements PickSource {
  static const String _cmsUrl = String.fromEnvironment(
    'CMS_URL',
    defaultValue: 'http://localhost:1337',
  );

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.parse('$_cmsUrl/api/picks');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load picks. Status code: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;

    return data
        .map((item) => Pick.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}