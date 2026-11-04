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

  /// Contentful puts the values under "fields". A field left empty is missing.
  /// trim() removes stray spaces or tabs that come from pasting.
  factory Pick.fromJson(Map<String, dynamic> item) {
    final f = (item['fields'] as Map<String, dynamic>?) ?? const {};
    return Pick(
      title: (f['title'] as String? ?? '').trim(),
      kind: (f['kind'] as String? ?? 'book').trim().toLowerCase(),
      externalId: (f['externalId'] as String? ?? '').trim(),
      note: (f['note'] as String? ?? '').trim(),
    );
  }
}
