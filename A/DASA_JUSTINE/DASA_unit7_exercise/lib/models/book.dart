
class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      workId: (json['key'] as String).split('/').last,
      title: json['title'] as String,
      authors: [
        ...?(json['author_name'] as List<dynamic>?)?.cast<String>(),
      ],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }
}
