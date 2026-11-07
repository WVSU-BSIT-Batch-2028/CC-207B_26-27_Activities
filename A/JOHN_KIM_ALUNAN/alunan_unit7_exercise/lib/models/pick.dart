enum PickKind { book, movie }

class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final kind = (json['kind'] as String? ?? 'book').toLowerCase();
    return Pick(
      title: json['title'] as String? ?? '',
      kind: kind == 'movie' ? PickKind.movie : PickKind.book,
      externalId: json['externalId'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}
