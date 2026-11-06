import 'package:http/http.dart' as http;

import 'pick.dart';

// Pass these with --dart-define (or --dart-define-from-file=cms.json):
//   OMDB_KEY, CMS_SPACE, CMS_TOKEN, CMS_ENVIRONMENT (optional)
const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');
const cmsEnvironment = String.fromEnvironment(
  'CMS_ENVIRONMENT',
  defaultValue: 'master',
);

bool get cmsConfigured => cmsSpace.isNotEmpty && cmsToken.isNotEmpty;

PickSource createPickSource(http.Client client) => ContentfulPickSource(
  client,
  spaceId: cmsSpace,
  token: cmsToken,
  environment: cmsEnvironment,
);
