class FairEvent {
  const FairEvent({
    required this.id,
    required this.orgId,
    required this.title,
    required this.startsAt,
    required this.venue,
    this.description = '',
    this.cancelled = false,
  });

  final String id;

  final String orgId;
  final String title;
  final DateTime startsAt;
  final String venue;
  final String description;

  final bool cancelled;
}
