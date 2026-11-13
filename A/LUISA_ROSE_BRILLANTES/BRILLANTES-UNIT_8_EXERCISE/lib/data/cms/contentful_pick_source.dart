import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/pick.dart';
import '../pick_source.dart';

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(this.client, {required this.baseUrl, this.token = ''});

  final http.Client client;
  final String baseUrl;
  final String token;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.parse('$baseUrl/entries').replace(
      queryParameters: {
        'content_type': 'myPicks',
        'order': '-sys.createdAt',
        'limit': '100',
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
    final items = (json['items'] as List<dynamic>? ?? const []);

    return items.map((item) {
      final map = item as Map<String, dynamic>;
      final sys = map['sys'] as Map<String, dynamic>? ?? const {};
      final fields = map['fields'] as Map<String, dynamic>? ?? const {};
      return Pick.fromJson({
        'id': sys['id'],
        'title': fields['title'],
        'kind': fields['kind'],
        'externalId': fields['externalId'],
        'note': fields['description'],
      });
    }).toList();
  }
}