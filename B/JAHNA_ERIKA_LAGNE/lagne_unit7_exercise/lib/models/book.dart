
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      authors: (json['author_name'] as List?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      firstPublishYear: json['first_publish_year'] is int
          ? json['first_publish_year'] as int
          : null,
      coverId: json['cover_i'] is int
          ? json['cover_i'] as int
          : null,
    );
  }

  String get authorName =>
      authors.isEmpty ? 'Unknown author' : authors.first;

  String? get coverUrl {
    if (coverId == null) return null;
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
}
