import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/pick.dart';
import 'api_exception.dart';
import 'pick_source.dart';

class ContentfulPickSource implements PickSource {
  const ContentfulPickSource();

  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpaceId.isEmpty || contentfulToken.isEmpty) {
      throw const ApiException(
        'Contentful is not set up. Run the app with '
        '--dart-define=CONTENTFUL_SPACE_ID=your-space-id and '
        '--dart-define=CONTENTFUL_TOKEN=your-delivery-token',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpaceId/environments/$contentfulEnvironment/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt'},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $contentfulToken'},
    );

    if (response.statusCode != 200) {
      throw ApiException('Contentful error (${response.statusCode}).');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;

    return [
      for (final item in items) Pick.fromJson(item as Map<String, dynamic>),
    ];
  }
}
