import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';

const contentfulSpaceId = String.fromEnvironment('CONTENTFUL_SPACE_ID');
const contentfulEnvironment = String.fromEnvironment(
  'CONTENTFUL_ENVIRONMENT',
  defaultValue: 'master',
);
const contentfulDeliveryToken = String.fromEnvironment(
  'CONTENTFUL_DELIVERY_TOKEN',
);

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  const ContentfulPickSource({
    this.spaceId = contentfulSpaceId,
    this.environment = contentfulEnvironment,
    this.deliveryToken = contentfulDeliveryToken,
    this.client,
  });

  final String spaceId;
  final String environment;
  final String deliveryToken;
  final http.Client? client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || deliveryToken.isEmpty) {
      throw const FormatException(
        'Contentful is not configured. Set CONTENTFUL_SPACE_ID and '
        'CONTENTFUL_DELIVERY_TOKEN with --dart-define.',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick'},
    );
    final response = client == null
        ? await http.get(
            uri,
            headers: {'Authorization': 'Bearer $deliveryToken'},
          )
        : await client!.get(
            uri,
            headers: {'Authorization': 'Bearer $deliveryToken'},
          );
    if (response.statusCode != 200) {
      throw Exception('Contentful request failed (${response.statusCode}).');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['items'] is! List) {
      throw const FormatException(
        'Contentful returned an invalid picks response.',
      );
    }
    return (decoded['items'] as List).map((record) {
      if (record is! Map<String, dynamic> ||
          record['fields'] is! Map<String, dynamic>) {
        throw const FormatException(
          'Contentful returned an invalid pick record.',
        );
      }
      final rawFields = record['fields'] as Map<String, dynamic>;
      final fields = <String, dynamic>{
        for (final entry in rawFields.entries)
          entry.key: _localizedValue(entry.value),
      };
      return Pick.fromJson(fields);
    }).toList();
  }

  static Object? _localizedValue(Object? value) {
    if (value is! Map<String, dynamic>) return value;
    return value.values.firstOrNull;
  }
}
