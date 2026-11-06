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

  /// The Open Library work ID (books) or the IMDb ID (movies).
  final String externalId;

  /// Why I recommend it. Written in the CMS.
  final String note;
}