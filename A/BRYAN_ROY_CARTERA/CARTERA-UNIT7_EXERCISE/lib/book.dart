class Book {
  final String id;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: (json['key'] as String).split('/').last,
      title: json['title'] as String? ?? 'Untitled',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }
}