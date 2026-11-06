/// One pick from the CMS: a book or a movie someone recommends.
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

  /// 'book' or 'movie'.
  final String kind;

  /// Open Library work id (book) or IMDb id (movie).
  final String externalId;
  final String note;

  bool get isBook => kind == 'book';
}

/// What the detail screen shows, whichever API it came from.
class PickDetail {
  const PickDetail({
    required this.title,
    required this.description,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String? imageUrl;
}

