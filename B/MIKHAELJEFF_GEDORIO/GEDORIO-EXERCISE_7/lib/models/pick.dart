
class Pick {
  final int id;
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
    // Supports both Strapi v4 and v5 responses.
    final data = json['attributes'] is Map<String, dynamic>
        ? json['attributes'] as Map<String, dynamic>
        : json;

    return Pick(
      id: json['id'] as int,
      title: data['title'] as String? ?? '',
      kind: data['kind'] as String? ?? '',
      externalId: data['externalId'] as String? ?? '',
      note: data['note'] as String? ?? '',
    );
  }
}
