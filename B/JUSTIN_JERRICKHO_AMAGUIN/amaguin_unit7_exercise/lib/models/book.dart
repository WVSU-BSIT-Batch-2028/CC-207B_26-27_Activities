class Book {
  const Book({
    required this.workId,
    required this.title,
    this.authors = const [],
    this.year,
    this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String? ?? 'Untitled book',
    authors: (json['author_name'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
    year: (json['first_publish_year'] as num?)?.toInt(),
    coverId: (json['cover_i'] as num?)?.toInt(),
  );

  String? get coverUrl => coverId != null && coverId! > 0
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg?default=false'
      : null;
}
