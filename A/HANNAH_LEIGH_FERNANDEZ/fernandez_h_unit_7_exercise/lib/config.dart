class SanityConfig {
  static const projectId = String.fromEnvironment(
    'SANITY_PROJECT_ID',
    defaultValue: '2e1jzlrm',
  );
  static const dataset = String.fromEnvironment(
    'SANITY_DATASET',
    defaultValue: 'production',
  );

  static const apiVersion = '2025-02-19';

  static String get baseUrl =>
      'https://$projectId.api.sanity.io/'
      'v$apiVersion/data/query/$dataset';
}
