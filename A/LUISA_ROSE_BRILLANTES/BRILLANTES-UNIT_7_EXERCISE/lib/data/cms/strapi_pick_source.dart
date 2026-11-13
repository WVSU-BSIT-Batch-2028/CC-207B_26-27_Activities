import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/pick.dart';
import '../pick_source.dart';

class StrapiPickSource implements PickSource {
  StrapiPickSource(this.client, {required this.baseUrl, this.token = ''});

  final http.Client client;
  final String baseUrl;
  final String token;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.parse('$baseUrl/api/picks').replace(
      queryParameters: {
        'sort': 'createdAt:desc',
        'pagination[pageSize]': '100',
      },
    );

    final headers = <String, String>{};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('CMS error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (json['data'] as List<dynamic>? ?? const []);

    return data
        .map((e) => Pick.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}