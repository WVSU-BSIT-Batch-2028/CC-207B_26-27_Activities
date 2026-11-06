const omdbKey = String.fromEnvironment('OMDB_KEY');
const contentfulSpaceId = String.fromEnvironment(
  'CONTENTFUL_SPACE_ID',
  defaultValue: '1znds4zzxlbv',
);

const contentfulToken = String.fromEnvironment(
  'CONTENTFUL_TOKEN',
  defaultValue: 'ObD2KbkA2xW9oGPPIPd_q7Ug9BM1DF2fah2nGV-_XLQ',
);

const contentfulEnvironment = String.fromEnvironment(
  'CONTENTFUL_ENVIRONMENT',
  defaultValue: 'master',
);