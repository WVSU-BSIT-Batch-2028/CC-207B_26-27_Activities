import '../models/pick.dart';

// Spec Part D.b: PickSource is an interface that CMS classes implement.
abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}
