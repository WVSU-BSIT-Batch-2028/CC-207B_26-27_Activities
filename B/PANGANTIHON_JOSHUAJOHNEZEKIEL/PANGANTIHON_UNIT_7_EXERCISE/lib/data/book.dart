class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'];
    if (key is! String || key.split('/').last.isEmpty) {
      throw const FormatException('The book has no Open Library work ID.');
    }

    return Book(
      workId: key.split('/').last,
      title: json['title'] as String? ?? 'Untitled',
      authors:
          (json['author_name'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  String get coverUrl => 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class BookDetails {
  const BookDetails({
    required this.title,
    required this.summary,
    required this.coverId,
    required this.year,
  });

  final String title;
  final String summary;
  final int? coverId;
  final int? year;
}
