class Pick {
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    // Contentful wraps custom fields inside an entry's "fields" object.
    final fields = json['fields'] is Map<String, dynamic>
        ? json['fields'] as Map<String, dynamic>
        : json;

    return Pick(
      title: fields['title'] as String? ?? 'Untitled pick',
      kind: (fields['kind'] as String? ?? '').toLowerCase().trim(),
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }

  bool get isBook => kind == 'book';
  bool get isMovie => kind == 'movie';
}
