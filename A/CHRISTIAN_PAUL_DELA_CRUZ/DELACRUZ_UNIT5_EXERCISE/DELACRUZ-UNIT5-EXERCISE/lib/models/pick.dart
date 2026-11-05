enum PickKind {
  book,
  movie;

  static PickKind parse(Object? value) => switch (value) {
    'book' => PickKind.book,
    'movie' => PickKind.movie,
    _ => throw FormatException('Unknown pick kind: $value'),
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
    if (title is! String || externalId is! String) {
      throw const FormatException('Contentful returned an invalid pick.');
    }
    return Pick(
      title: title,
      kind: PickKind.parse(json['kind']),
      externalId: externalId,
      note: json['note'] as String? ?? '',
    );
  }

  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}
