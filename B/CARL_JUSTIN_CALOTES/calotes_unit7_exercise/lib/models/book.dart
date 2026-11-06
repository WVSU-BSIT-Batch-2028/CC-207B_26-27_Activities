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
    final String key = json['key'] ?? '';

    return Book(
      id: key.split('/').last,
      title: json['title'] ?? 'Untitled',
      authors: List<String>.from(json['author_name'] ?? []),
      year: json['first_publish_year'],
      coverId: json['cover_i'],
    );
  }
}
