enum PickKind {
  book,
  movie;

  static PickKind parse(Object? value) {
    return switch (value) {
      'book' => PickKind.book,
      'movie' => PickKind.movie,
      _ => throw FormatException('Unknown pick kind: $value'),
    };
  }
}

class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String title;
  final PickKind kind;
  final String externalId;
  final String note;

  factory Pick.fromContentful(Map<String, dynamic> item) {
    final fields = item['fields'] as Map<String, dynamic>;
    return Pick(
      title: fields['title'] as String,
      kind: PickKind.parse(fields['kind']),
      externalId: fields['externalId'] as String,
      note: fields['note'] as String? ?? '',
    );
  }
}
