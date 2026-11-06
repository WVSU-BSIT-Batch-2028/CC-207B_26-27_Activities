
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

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

  bool get isBook => kind == 'book';

  
  factory Pick.fromJson(Map<String, dynamic> json) {
    final sys = json['sys'] as Map<String, dynamic>;
    final fields = json['fields'] as Map<String, dynamic>;
    return Pick(
      id: sys['id'] as String,
      title: fields['title'] as String? ?? 'Untitled',
      kind: (fields['kind'] as String? ?? 'book').trim().toLowerCase(),
      externalId: (fields['externalId'] as String? ?? '').trim(),
      note: fields['note'] as String? ?? '',
    );
  }
}


class MediaDetails {
  final String title;
  final String? imageUrl;
  final String? year;
  final String summary;

  const MediaDetails({
    required this.title,
    this.imageUrl,
    this.year,
    required this.summary,
  });
}