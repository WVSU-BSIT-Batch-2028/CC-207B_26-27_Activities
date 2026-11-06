import '../services/api_exception.dart';

enum PickKind { book, movie }

class Pick {
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String title;
  final PickKind kind;
  final String externalId;
  final String note;

  factory Pick.fromJson(Map<String, dynamic> fields) {
    final kind = switch (fields['kind']) {
      'book' => PickKind.book,
      'movie' => PickKind.movie,
      _ => throw const ApiException(
        'A pick has an invalid kind. Use book or movie in Contentful.',
      ),
    };
    final id = (fields['externalId'] as String? ?? '').trim();
    final validId = kind == PickKind.book
        ? RegExp(r'^OL\d+W$').hasMatch(id)
        : RegExp(r'^tt\d+$').hasMatch(id);
    if (!validId) {
      throw const ApiException(
        'A pick has an invalid externalId. Copy its ID from Books or Movies.',
      );
    }
    return Pick(
      title: fields['title'] as String? ?? 'Untitled pick',
      kind: kind,
      externalId: id,
      note: fields['note'] as String? ?? '',
    );
  }
}
