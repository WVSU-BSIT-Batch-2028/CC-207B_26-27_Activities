// Values passed in with --dart-define (never written in the source).
//   flutter run --dart-define-from-file=cms.json
// cms.json: { "CMS": "contentful", "CMS_SPACE": "...", "CMS_TOKEN": "...",
//             "OMDB_KEY": "..." }
const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

