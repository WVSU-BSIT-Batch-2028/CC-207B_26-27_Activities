class Pick {
  final String id;
  final String title;
  final String kind; // 'book' or 'movie'
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

  factory Pick.fromContentful(Map<String, dynamic> item) {
    final sys = item['sys'] as Map<String, dynamic>? ?? {};
    final fields = item['fields'] as Map<String, dynamic>? ?? {};
    return Pick(
      id: sys['id'] as String? ?? '',
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }

  factory Pick.fromJson(Map<String, dynamic> json) => Pick(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? 'Untitled',
        kind: json['kind'] as String? ?? 'book',
        externalId: json['externalId'] as String? ?? '',
        note: json['note'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'kind': kind,
        'externalId': externalId,
        'note': note,
      };
}

