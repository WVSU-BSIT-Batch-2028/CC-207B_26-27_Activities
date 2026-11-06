import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

class StrapiEventSource implements EventSource {
  StrapiEventSource(this.client, {required this.baseUrl, this.token = ''});

  final http.Client client;

  final String baseUrl;

  final String token;

  @override
  String get name => 'Strapi';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    final uri = Uri.parse(baseUrl);
    final headers = <String, String>{};
    final json = await getJson(client, uri, cms: name, headers: headers);

    return const [];
  }
}
