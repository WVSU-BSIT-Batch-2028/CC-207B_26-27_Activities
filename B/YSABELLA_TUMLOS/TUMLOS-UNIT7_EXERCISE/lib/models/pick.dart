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
  final String kind;
  final String externalId;
  final String note;

  bool get isBook => kind.trim().toLowerCase() == 'book';

  factory Pick.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? const {};

    return Pick(
      id: (json['sys'] as Map<String, dynamic>)['id'] as String,
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}
