/// One book from an Open Library search.
class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  // Open Library sends key as "/works/OL45883W"; we keep only "OL45883W".
  // author_name, first_publish_year and cover_i can be missing, so they
  // are read as nullable types.
  factory Book.fromJson(Map<String, dynamic> json) => Book(
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String,
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );
}

