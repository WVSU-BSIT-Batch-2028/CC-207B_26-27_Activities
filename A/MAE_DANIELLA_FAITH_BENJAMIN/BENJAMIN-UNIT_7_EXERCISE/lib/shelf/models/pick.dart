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

  factory Pick.fromContentful(Map<String, dynamic> entry) {
    final system = entry['sys'] as Map<String, dynamic>? ?? {};
    final fields = entry['fields'] as Map<String, dynamic>? ?? {};
    final rawKind = fields['kind'] as String? ?? '';
    final kind = switch (rawKind.toLowerCase()) {
      'book' => PickKind.book,
      'movie' => PickKind.movie,
      _ => throw FormatException('Pick kind must be book or movie.'),
    };
    return Pick(
      id: system['id'] as String? ?? '',
      title: fields['title'] as String? ?? '',
      kind: kind,
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}
