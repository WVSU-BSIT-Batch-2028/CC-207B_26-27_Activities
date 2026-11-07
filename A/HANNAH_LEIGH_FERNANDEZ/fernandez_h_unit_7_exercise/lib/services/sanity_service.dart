
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/pick.dart';
import 'pick_source.dart';

class SanityService implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    final url = Uri.parse(SanityConfig.baseUrl).replace(
      queryParameters: {
        'query':
            '*[_type == "pick"] | order(_createdAt desc) '
            '{_id, title, kind, externalId, note}',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['result'] as List<dynamic>;

      return results
          .map((item) => Pick.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList();
    } else {
      throw Exception(
        'Failed to load picks: ${response.body}',
      );
    }
  }
}
