import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';
import 'pick_source.dart';

const cmsName = String.fromEnvironment('CMS');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');
const cmsEnvironment = String.fromEnvironment(
  'CMS_ENVIRONMENT',
  defaultValue: 'master',
);

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    required this.spaceId,
    required this.token,
    this.environment = 'master',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String spaceId;
  final String token;
  final String environment;
  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty) {
      throw const ApiException(
        'CMS_SPACE is missing. Configure your Contentful space ID.',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'limit': '100'},
    );
    final headers = <String, String>{};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await _client.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw ApiException('Contentful answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    return items.map((item) {
      final entry = item as Map<String, dynamic>;
      final sys = entry['sys'] as Map<String, dynamic>? ?? const {};
      final fields = entry['fields'] as Map<String, dynamic>? ?? const {};
      final kind = (fields['kind'] as String? ?? '').toLowerCase();
      if (kind != 'book' && kind != 'movie') {
        throw FormatException('Unknown pick kind: $kind');
      }
      return Pick(
        id: sys['id'] as String? ?? '',
        title: fields['title'] as String? ?? '',
        kind: kind,
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      );
    }).toList();
  }

  void close() => _client.close();
}

ContentfulPickSource createPickSource() {
  if (cmsName.isNotEmpty && cmsName != 'contentful') {
    throw ApiException(
      'This exercise is configured for Contentful, but CMS is "$cmsName".',
    );
  }
  return ContentfulPickSource(
    spaceId: cmsSpace,
    token: cmsToken,
    environment: cmsEnvironment,
  );
}
