import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'pick.dart';
import 'pick_source.dart';

class StrapiPickSource implements PickSource {
  StrapiPickSource(this.client, {required this.baseUrl, this.token = ''});

  final http.Client client;
  final String baseUrl;
  final String token;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (baseUrl.isEmpty) {
      throw const ApiException(
        'Set CMS_URL to your Strapi server address in the app launch settings.',
      );
    }

    final normalizedBaseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$normalizedBaseUrl/api/picks')
        .replace(queryParameters: const {'pagination[pageSize]': '100'});
    final headers = <String, String>{};
    if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

    final json = await getJson(
      client,
      uri,
      headers: headers,
      service: 'Strapi',
    );
    final data = json['data'];
    if (data is! List) {
      throw const ApiException(
        'Strapi returned an unexpected response. Check the Pick content type and API permissions.',
      );
    }

    return data.map((raw) {
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Strapi returned an invalid pick.');
      }
      final attributes = raw['attributes'];
      final fields = attributes is Map<String, dynamic> ? attributes : raw;
      return Pick.fromJson(fields);
    }).toList();
  }
}
