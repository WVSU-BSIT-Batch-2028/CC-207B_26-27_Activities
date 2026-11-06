import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pick.dart';

const contentfulSpaceId = String.fromEnvironment('CONTENTFUL_SPACE_ID');
const contentfulAccessToken = String.fromEnvironment('CONTENTFUL_ACCESS_TOKEN');

/// Every pick loaded from the CMS. The Books and Movies tabs listen to this
/// so each shows the picks of its own kind.
final ValueNotifier<List<Pick>> allPicks = ValueNotifier<List<Pick>>([]);

/// IDs (OL... / tt...) of every pick, used to mark search results.
final ValueNotifier<Set<String>> pickedIds = ValueNotifier<Set<String>>({});

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  // The content type's API identifier in Contentful (case-sensitive).
  static const _contentType = 'myShelf';

  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpaceId.isEmpty || contentfulAccessToken.isEmpty) {
      throw const ApiException(
        'Contentful keys missing. Run with --dart-define-from-file=keys.json',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpaceId/environments/master/entries',
      {'content_type': _contentType},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $contentfulAccessToken'},
    );
    if (response.statusCode != 200) {
      String detail = '';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        detail = body['message'] as String? ?? '';
      } catch (_) {}
      throw ApiException(
        'Contentful error (${response.statusCode}) $detail'.trim(),
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>?) ?? [];
    return items.map((e) => Pick.fromJson(e as Map<String, dynamic>)).toList();
  }
}