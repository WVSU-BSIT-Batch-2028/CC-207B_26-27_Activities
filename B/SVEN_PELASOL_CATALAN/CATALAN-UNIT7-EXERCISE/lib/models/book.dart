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

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        // Open Library returns keys such as /works/OL27482W. The CMS stores
        // only the final ID segment, as required by the exercise.
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String? ?? 'Untitled',
        // author_name is absent on some search results and is a list.
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class BookDetails {
  final String title;
  final String description;
  final int? coverId;

  const BookDetails({
    required this.title,
    required this.description,
    this.coverId,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    // Open Library descriptions can be a plain String or an object with value.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = (json['covers'] as List<dynamic>?)
            ?.whereType<int>()
            .toList(growable: false) ??
        const <int>[];

    return BookDetails(
      title: json['title'] as String? ?? 'Untitled',
      description: description,
      coverId: covers.isEmpty ? null : covers.first,
    );
  }

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
}
