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
    final fields = json['fields'] as Map<String, dynamic>;

    String getField(String name) {
      final value = fields[name];

      if (value is String) return value;

      if (value is Map) {
        return value.values.first.toString();
      }

      return '';
    }

    return Pick(
      id: json['sys']['id'] as String? ?? '',
      title: getField('title'),
      kind: getField('kind'),
      externalId: getField('externalId'),
      note: getField('note'),
    );
  }
}