class AppConfig {
  static const String omdbKey = String.fromEnvironment('OMDB_KEY');
  static const String contentfulSpaceId = String.fromEnvironment(
    'CONTENTFUL_SPACE_ID',
    defaultValue: 'yuf4ngrc1z39',
  );
  static const String contentfulToken = String.fromEnvironment(
    'CONTENTFUL_TOKEN',
    defaultValue: '0jyD6Aa2AtU18EJIJ-Wqaey8jz1twkgQ95AsgjMuSyw',
  );
}