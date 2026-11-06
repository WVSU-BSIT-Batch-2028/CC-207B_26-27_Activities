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
      id: json['sys']?['id']?.toString() ?? '',
      title: json['fields']?['title']?.toString() ?? '',
      kind: json['fields']?['kind']?.toString() ?? '',
      externalId: json['fields']?['externalId']?.toString() ?? '',
      note: json['fields']?['note']?.toString() ?? '',
    );
  }
}