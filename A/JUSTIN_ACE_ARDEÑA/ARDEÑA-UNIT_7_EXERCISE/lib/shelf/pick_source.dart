import 'pick.dart';

/// Where the picks come from. The screens only know this interface, so
/// another CMS could be plugged in without changing them.
abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

