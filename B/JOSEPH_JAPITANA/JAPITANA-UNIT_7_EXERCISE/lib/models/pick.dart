class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  bool get isBook => kind == 'book';

  factory Pick.fromJson(Map<String, dynamic> json) {
    // Contentful leaves out empty fields, so every field may be missing.
    final fields = (json['fields'] as Map<String, dynamic>?) ?? const {};
    return Pick(
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? '',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}