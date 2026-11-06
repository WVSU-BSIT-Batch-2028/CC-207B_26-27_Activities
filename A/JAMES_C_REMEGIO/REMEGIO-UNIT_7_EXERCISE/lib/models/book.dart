/// One Open Library search hit.
class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
  });

  /// The last piece of the work key, such as `OL27482W`.
  final String workId;
  final String title;
  final List<String> authors;

  /// First publication year from search. Missing for some works.
  final int? year;

  /// Open Library cover id. Missing for some works.
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String,
        // author_name is missing for some books, and it is a list.
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );

  String get authorLabel => authors.isEmpty ? 'Unknown author' : authors.first;

  String get yearLabel => year?.toString() ?? 'Year unknown';
}

/// Cover URL for a search or work-detail cover id.
String openLibraryCoverUrl(int coverId) =>
    'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
