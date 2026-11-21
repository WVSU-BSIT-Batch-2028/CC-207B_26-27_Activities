import '../data/orgs.dart';
import 'registration.dart';

class Membership {
  const Membership({required this.org, required this.registration});

  final Org org;
  final Registration registration;
}
