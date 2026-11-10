class Pick {
  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  bool get isBook => kind.toLowerCase() == 'book';
  bool get isMovie => kind.toLowerCase() == 'movie';

  factory Pick.fromContentful(Map<String, dynamic> entry) {
    final sys = entry['sys'] as Map<String, dynamic>? ?? {};
    final fields = entry['fields'] as Map<String, dynamic>? ?? {};
    return Pick(
      id: sys['id'] as String? ?? '',
      title: fields['title'] as String? ?? '',
      kind: fields['kind'] as String? ?? '',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}

