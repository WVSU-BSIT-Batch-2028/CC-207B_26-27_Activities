class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'];
    final title = json['title'];
    if (key is! String || key.split('/').last.isEmpty || title is! String) {
      throw const FormatException('Open Library returned an invalid book.');
    }
    return Book(
      workId: key.split('/').last,
      title: title,
      authors: (json['author_name'] as List<dynamic>?)?.cast<String>() ?? [],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  String? get author => authors.isEmpty ? null : authors.first;
  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class BookWork {
  const BookWork({
    required this.title,
    required this.description,
    this.year,
    this.coverId,
  });

  factory BookWork.fromJson(Map<String, dynamic> json) {
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'];
    final rawYear = json['first_publish_date'];
    final year = rawYear is String
        ? int.tryParse(RegExp(r'\d{4}').firstMatch(rawYear)?.group(0) ?? '')
        : null;
    return BookWork(
      title: json['title'] as String? ?? 'Unknown title',
      description: description,
      year: year,
      coverId: covers is List && covers.isNotEmpty
          ? covers.first as int?
          : null,
    );
  }

  final String title;
  final String description;
  final int? year;
  final int? coverId;

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
}
