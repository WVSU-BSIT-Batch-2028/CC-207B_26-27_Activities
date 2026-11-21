enum Committee {
  events('Events'),
  logistics('Logistics'),
  media('Media'),
  finance('Finance');

  const Committee(this.label);
  final String label;
}

class Registration {
  const Registration({
    required this.fullName,
    required this.email,
    required this.studentId,
    required this.yearLevel,
    required this.committee,
    required this.hoursPerWeek,
    required this.wantsUpdates,
  });

  final String fullName;
  final String email;
  final String studentId;
  final int yearLevel;
  final Committee committee;
  final int hoursPerWeek;
  final bool wantsUpdates;
}
