class Book {
  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
  });

  final String id;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';
    final authors = json['author_name'] as List<dynamic>? ?? const [];

    return Book(
      id: key.split('/').last,
      title: json['title'] as String? ?? 'Untitled',
      authors: authors.whereType<String>().toList(),
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}
