class Book {
  final String key;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;

  const Book({
    required this.key,
    required this.title,
    this.authors = const [],
    this.firstPublishYear,
    this.coverId,
  });

  String get workId {
    return key.split('/').last;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'] as String,
      title: json['title'] as String,
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }
}
