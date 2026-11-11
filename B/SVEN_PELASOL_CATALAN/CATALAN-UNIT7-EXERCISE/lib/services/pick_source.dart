import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_exception.dart';
import '../models/pick.dart';

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final String spaceId;
  final String token;
  final String environment;

  const ContentfulPickSource({
    this.spaceId = const String.fromEnvironment('CMS_SPACE'),
    this.token = const String.fromEnvironment('CMS_TOKEN'),
    this.environment = const String.fromEnvironment(
      'CMS_ENVIRONMENT',
      defaultValue: 'master',
    ),
  });

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.trim().isEmpty || token.trim().isEmpty) {
      throw const ApiException(
        'Contentful is not configured. Supply CMS_SPACE and CMS_TOKEN using --dart-define.',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      const <String, String>{'content_type': 'pick'},
    );

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ApiException(
        'Contentful denied access. Check your Space ID and Content Delivery API token.',
      );
    }
    if (response.statusCode == 404) {
      throw const ApiException(
        'Contentful returned 404. Check the space, environment, and Pick content type ID.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Contentful request failed (${response.statusCode}). Please try again.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Contentful returned an unexpected response.');
    }

    final items = decoded['items'];
    if (items is! List) return const <Pick>[];

    return items
        .whereType<Map<String, dynamic>>()
        .map(Pick.fromJson)
        .where((pick) => pick.externalId.trim().isNotEmpty)
        .toList(growable: false);
  }
}
