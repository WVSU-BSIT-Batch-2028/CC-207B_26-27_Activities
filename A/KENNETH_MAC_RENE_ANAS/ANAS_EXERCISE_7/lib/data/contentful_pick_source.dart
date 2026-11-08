import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.deliveryToken,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String deliveryToken;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'pick',
        'limit': '100',
        'access_token': deliveryToken,
      },
    );
    final response = await client.get(uri).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw const ApiException(
        'Contentful request timed out. Check your internet connection and retry.',
      ),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Contentful returned HTTP ${response.statusCode}. '
        'Check the Space ID, environment, and Content Delivery API token.',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    final picks = <Pick>[];
    for (final item in items) {
      final entry = item as Map<String, dynamic>;
      final sys = entry['sys'];
      Object? typeId;
      if (sys is Map<String, dynamic>) {
        final contentType = sys['contentType'];
        if (contentType is Map<String, dynamic>) {
          final contentTypeSys = contentType['sys'];
          if (contentTypeSys is Map<String, dynamic>) {
            typeId = contentTypeSys['id'];
          }
        }
      }
      if (typeId is String && typeId != 'pick') continue;
      picks.add(Pick.fromContentful(entry));
    }
    return picks;
  }
}
