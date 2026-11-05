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

  factory Pick.fromJson(Map<String, dynamic> json) {
    return Pick(
      id: json['documentId']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      kind: json['kind']?.toString() ?? '',
      externalId: json['externalId']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }

  bool get isBook => kind == 'book';

  bool get isMovie => kind == 'movie';
}