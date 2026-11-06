enum PickKind {
  book,
  movie;

  static PickKind parse(Object? value) => switch (value) {
    'book' => PickKind.book,
    'movie' => PickKind.movie,
    _ => throw const FormatException('Pick kind must be book or movie.'),
  };
}

class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final externalId = json['externalId'];
    final note = json['note'];
    if (title is! String || externalId is! String || externalId.isEmpty) {
      throw const FormatException(
        'Each Strapi pick needs a title and externalId.',
      );
    }

    return Pick(
      title: title,
      kind: PickKind.parse(json['kind']),
      externalId: externalId,
      note: note as String? ?? '',
    );
  }

  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}
