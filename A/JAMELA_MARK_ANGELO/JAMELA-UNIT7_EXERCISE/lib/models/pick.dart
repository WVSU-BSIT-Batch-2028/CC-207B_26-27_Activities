class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String title;
  final String kind;
  final String externalId;
  final String note;

  factory Pick.fromContentful(Map<String, dynamic> json) {
    final fields = Map<String, dynamic>.from(json['fields'] as Map);

    return Pick(
      title: fields['title'] as String,
      kind: fields['kind'] as String,
      externalId: fields['externalId'] as String,
      note: fields['note'] as String? ?? '',
    );
  }
}
