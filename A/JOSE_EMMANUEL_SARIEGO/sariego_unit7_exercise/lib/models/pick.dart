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
    final fields = json['fields'] as Map<String, dynamic>;

    String getField(String name) {
      final value = fields[name];

      if (value is Map<String, dynamic>) {
        return value['en-US']?.toString() ?? '';
      }

      return value?.toString() ?? '';
    }

    return Pick(
      title: getField('title'),
      kind: getField('kind'),
      externalId: getField('externalId'),
      note: getField('note'),
    );
  }
}
