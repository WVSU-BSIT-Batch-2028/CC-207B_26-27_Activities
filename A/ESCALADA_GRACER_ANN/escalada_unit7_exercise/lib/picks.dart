import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

const cmsUrl = String.fromEnvironment(
  'CMS_URL',
  defaultValue: 'http://localhost:1337',
);
const cmsToken = String.fromEnvironment('CMS_TOKEN');

class Pick {
  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    // Strapi 5 puts fields directly on the item; Strapi 4 nests them in "attributes".
    final data = (json['attributes'] as Map<String, dynamic>?) ?? json;
    return Pick(
      title: data['title'] as String? ?? '',
      kind: data['kind'] as String? ?? 'book',
      externalId: data['externalId'] as String? ?? '',
      note: data['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class StrapiPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    final response = await http.get(
      Uri.parse('$cmsUrl/api/picks'),
      headers: {
        if (cmsToken.isNotEmpty) 'Authorization': 'Bearer $cmsToken',
      },
    );
    if (response.statusCode != 200) {
      throw ApiException('CMS error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['data'] as List<dynamic>;
    return [for (final i in items) Pick.fromJson(i as Map<String, dynamic>)];
  }
}