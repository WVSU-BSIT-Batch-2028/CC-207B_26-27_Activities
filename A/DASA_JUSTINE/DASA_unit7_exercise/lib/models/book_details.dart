class BookDetails {
  final String title;
  final String description;
  final List<String> authors;
  final List<String> subjects;
  final List<int> covers;

  const BookDetails({
    required this.title,
    required this.description,
    required this.authors,
    required this.subjects,
    required this.covers,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    final rawDescription = json['description'];

    String description = '';

    if (rawDescription is String) {
      description = rawDescription;
    } else if (rawDescription is Map<String, dynamic>) {
      description = rawDescription['value'] ?? '';
    }

    return BookDetails(
      title: json['title'] ?? 'Unknown title',
      description: description,
      authors: [],
      subjects: (json['subjects'] as List<dynamic>?)
              ?.take(10)
              .map((item) => item.toString())
              .toList() ??
          [],
      covers: (json['covers'] as List<dynamic>?)
              ?.whereType<int>()
              .toList() ??
          [],
    );
  }
}