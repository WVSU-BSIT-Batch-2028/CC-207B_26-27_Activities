import 'pick.dart';

const cmsUrl = String.fromEnvironment(
  'CMS_URL',
  defaultValue: 'http://localhost:1337',
);
const cmsToken = String.fromEnvironment('CMS_TOKEN');
const omdbKey = String.fromEnvironment('OMDB_KEY');

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}
