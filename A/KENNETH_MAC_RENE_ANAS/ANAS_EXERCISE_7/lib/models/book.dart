class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
    this.summary = '',
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;
  final String summary;

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';

  factory Book.fromSearchJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String? ?? 'Untitled',
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );

  factory Book.fromDetailsJson(String workId, Map<String, dynamic> json) {
    final rawDescription = json['description'];
    final description = switch (rawDescription) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>?;
    final coverId = covers == null || covers.isEmpty
        ? null
        : covers.first as int;
    return Book(
      workId: workId,
      title: json['title'] as String? ?? 'Untitled',
      authors: const [],
      year: null,
      coverId: coverId,
      summary: description,
    );
  }
}
