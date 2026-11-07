const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');
const cmsEnvironment = String.fromEnvironment(
  'CMS_ENVIRONMENT',
  defaultValue: 'master',
);
