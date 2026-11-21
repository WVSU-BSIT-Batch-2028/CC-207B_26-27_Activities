enum PickKind { book, movie }

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}

class PickDetails {
  const PickDetails({
    required this.title,
    required this.summary,
    this.subtitle = '',
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String summary;
  final String? imageUrl;
}
