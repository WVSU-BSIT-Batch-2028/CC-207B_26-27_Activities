import '../models/pick.dart';

/// Where My Picks reads recommendations. Screens depend on this, not on Contentful.
abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}
