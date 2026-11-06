import 'book.dart';

/// Fields read from `https://openlibrary.org/works/WORK_ID.json`.
///
/// That document is not a search hit. It has no `author_name` or `cover_i`,
/// and it may omit a publication date entirely.
class BookDetails {
  const BookDetails({
    required this.title,
    required this.year,
    required this.coverId,
    required this.summary,
  });

  final String title;
  final int? year;
  final int? coverId;
  final String summary;

  factory BookDetails.fromWorkJson(Map<String, dynamic> json) {
    final Object? title = json['title'];
    return BookDetails(
      title: title is String && title.trim().isNotEmpty
          ? title.trim()
          : 'Untitled',
      year: yearFromOpenLibraryWork(json),
      coverId: coverIdFromOpenLibraryWork(json['covers']),
      summary: descriptionFromOpenLibrary(json['description']),
    );
  }

  String? get coverUrl =>
      coverId == null ? null : openLibraryCoverUrl(coverId!);
}

/// Open Library sends a plain string or an object with a string `value`.
String descriptionFromOpenLibrary(Object? raw) {
  final String text = switch (raw) {
    final String value => value,
    {'value': final String value} => value,
    _ => '',
  };
  final String trimmed = text.trim();
  if (trimmed.isEmpty) return 'No description yet.';
  return trimmed;
}

/// Uses `first_publish_date` only. `created` is when the record was added.
int? yearFromOpenLibraryWork(Map<String, dynamic> json) {
  final Object? raw = json['first_publish_date'];
  if (raw is! String) return null;
  final RegExpMatch? match = RegExp(r'\b(\d{4})\b').firstMatch(raw);
  if (match == null) return null;
  return int.tryParse(match.group(1)!);
}

/// The first positive cover id. Open Library uses `-1` as a placeholder.
int? coverIdFromOpenLibraryWork(Object? covers) {
  if (covers is! List) return null;
  for (final Object? cover in covers) {
    final int? id = switch (cover) {
      final int value => value,
      final num value when value == value.roundToDouble() => value.toInt(),
      _ => null,
    };
    if (id != null && id > 0) return id;
  }
  return null;
}
