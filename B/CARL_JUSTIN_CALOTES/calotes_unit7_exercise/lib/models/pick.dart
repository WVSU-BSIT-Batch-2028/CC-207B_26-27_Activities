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
    return Pick(
      title: json['title'] ?? 'Untitled',
      kind: json['kind'] ?? '',
      externalId: json['externalId'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
