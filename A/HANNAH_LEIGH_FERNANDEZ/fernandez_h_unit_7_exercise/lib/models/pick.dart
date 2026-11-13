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
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      externalId: json['externalId'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }
}
