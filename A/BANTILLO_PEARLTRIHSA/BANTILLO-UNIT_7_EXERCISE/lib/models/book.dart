class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';

    return Book(
      workId: key.split('/').last,
      title: json['title'] as String? ?? 'Untitled',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }
}
