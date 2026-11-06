import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';
import 'pick_source.dart';

const contentfulSpace = String.fromEnvironment('CMS_SPACE');
const contentfulToken = String.fromEnvironment('CMS_TOKEN');

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.trim().isEmpty || token.trim().isEmpty) {
      throw const ApiException(
        'Contentful is not configured. Run the app with CMS_SPACE and CMS_TOKEN.',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'order': 'fields.title', 'limit': '100'},
    );
    final http.Response response;
    try {
      response = await client
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 15));
    } on Exception {
      throw const ApiException('No connection to Contentful. Try again.');
    }
    if (response.statusCode != 200) {
      final message = switch (response.statusCode) {
        401 || 403 => 'Contentful refused the request. Check the token and read permission.',
        404 =>
          'Contentful could not find the Pick content type. Check its API ID.',
        >= 500 => 'Contentful is having problems. Try again later.',
        _ => 'Contentful answered ${response.statusCode}.',
      };
      throw ApiException(message);
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Contentful returned an invalid response.');
    }
    final entries = decoded['items'] as List<dynamic>? ?? const [];
    try {
      return entries
          .whereType<Map<String, dynamic>>()
          .map(Pick.fromContentful)
          .toList();
    } on FormatException catch (error) {
      throw ApiException('Could not read a Contentful pick: ${error.message}');
    }
  }
}
