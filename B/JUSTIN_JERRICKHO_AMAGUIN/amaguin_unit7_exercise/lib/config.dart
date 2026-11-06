const String cmsSpace = String.fromEnvironment('CMS_SPACE');

const String cmsToken = String.fromEnvironment('CMS_TOKEN');

const String cmsEnvironment = String.fromEnvironment(
  'CMS_ENVIRONMENT',
  defaultValue: 'master',
);

const String omdbKey = String.fromEnvironment('OMDB_KEY');
