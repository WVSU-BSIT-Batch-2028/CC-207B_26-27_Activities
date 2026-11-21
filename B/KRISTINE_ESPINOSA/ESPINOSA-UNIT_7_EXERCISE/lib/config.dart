import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

final http.Client httpClient = http.Client();
