import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/pick.dart';
import 'api_exception.dart';
import 'pick_source.dart';

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    String? spaceId,
    String? token,
    String? environment,
    http.Client? client,
  }) : _spaceId = spaceId ?? cmsSpace,
       _token = token ?? cmsToken,
       _environment = environment ?? cmsEnvironment,
       _client = client ?? http.Client();

  final String _spaceId;
  final String _token;
  final String _environment;
  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_spaceId.trim().isEmpty || _token.trim().isEmpty) {
      throw const ApiException(
        'CMS_SPACE and CMS_TOKEN are required for Contentful.',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_spaceId/environments/$_environment/entries',
      {'content_type': 'pick', 'limit': '100'},
    );
    try {
      final response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $_token'})
          .timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Contentful answered ${response.statusCode}.');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Contentful returned an invalid response.');
      }
      final items = decoded['items'] as List<dynamic>? ?? const [];
      return items.whereType<Map<String, dynamic>>().map((entry) {
        final fields = entry['fields'];
        if (fields is! Map<String, dynamic>) {
          throw const ApiException('Contentful returned a pick without fields.');
        }
        return Pick.fromJson(fields);
      }).toList();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Contentful took too long to answer.');
    } on http.ClientException {
      throw const ApiException('Could not connect to Contentful.');
    } on FormatException {
      throw const ApiException('Contentful returned invalid JSON.');
    }
  }
}
