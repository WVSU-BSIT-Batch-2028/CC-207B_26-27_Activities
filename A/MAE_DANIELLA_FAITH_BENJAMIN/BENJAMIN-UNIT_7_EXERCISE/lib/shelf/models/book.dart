class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';
    final authorNames = json['author_name'] as List<dynamic>?;
    return Book(
      workId: key.split('/').last,
      title: json['title'] as String? ?? '',
      authors: [...?authorNames?.cast<String>()],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  String? get coverUrl {
    final id = coverId;
    if (id == null || id <= 0) return null;
    return 'https://covers.openlibrary.org/b/id/$id-M.jpg';
  }
}

class BookDetails {
  const BookDetails({
    required this.title,
    required this.year,
    required this.summary,
    required this.coverUrl,
  });

  final String title;
  final String? year;
  final String summary;
  final String? coverUrl;
}
