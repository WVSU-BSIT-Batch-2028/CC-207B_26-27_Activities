import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

class SanityEventSource implements EventSource {
  SanityEventSource(
    this.client, {
    required this.projectId,
    this.dataset = 'production',
    this.token = '',
  });

  final http.Client client;
  final String projectId;
  final String dataset;

  final String token;

  static const query =
      '*[_type == "fairEvent"] | order(startsAt asc) '
      '{_id, title, orgId, startsAt, venue, description, cancelled}';

  @override
  String get name => 'Sanity';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    final uri = Uri.https('$projectId.apicdn.sanity.io');
    final headers = <String, String>{};
    final json = await getJson(client, uri, cms: name, headers: headers);

    return const [];
  }
}
