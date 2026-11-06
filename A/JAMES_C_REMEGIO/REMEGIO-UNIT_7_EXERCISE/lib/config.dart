/// Values compiled in with `--dart-define` or `--dart-define-from-file`.
///
/// `cms.json` holds the local values and is gitignored. `cms.example.json`
/// shows the same keys with placeholders.
const omdbKey = String.fromEnvironment('OMDB_KEY');

const cmsName = String.fromEnvironment('CMS');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');
