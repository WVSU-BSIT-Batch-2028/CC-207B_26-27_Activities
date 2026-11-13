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

  factory Pick.fromJson(Map<String, dynamic> json) {
    final kind = (json['kind'] ?? '').toString().toLowerCase() == 'movie'
        ? PickKind.movie
        : PickKind.book;

    return Pick(
      id: (json['documentId'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      kind: kind,
      externalId: (json['externalId'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
    );
  }
}