import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/pick.dart';
import 'api_exception.dart';
import 'pick_source.dart';

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({http.Client? client})
      : client = client ?? http.Client();

  final http.Client client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (cmsSpace.isEmpty || cmsToken.isEmpty) {
      throw const ApiException(
        'CMS settings missing. Run with --dart-define-from-file=keys.json',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cmsSpace/environments/master/entries',
      {'content_type': 'pick', 'order': 'fields.title'},
    );

    final http.Response response;
    try {
      response = await client
          .get(uri, headers: {'Authorization': 'Bearer $cmsToken'})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('The CMS took too long. Pull down to retry.');
    } on http.ClientException {
      throw const ApiException(
        'No connection. Check your internet and pull down to retry.',
      );
    }

    if (response.statusCode == 401) {
      throw const ApiException('The CMS token was rejected. Check keys.json.');
    }
    if (response.statusCode != 200) {
      throw ApiException('The CMS answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>?) ?? const [];
    return [
      for (final item in items) Pick.fromJson(item as Map<String, dynamic>),
    ];
  }
}