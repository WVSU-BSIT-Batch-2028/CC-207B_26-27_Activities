import '../models/pick.dart';

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}
