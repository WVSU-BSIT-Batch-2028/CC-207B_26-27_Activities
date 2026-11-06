class ShelfDetail {
  const ShelfDetail({
    required this.title,
    required this.summary,
    this.year,
    this.imageUrl,
  });

  final String title;
  final String summary;
  final String? year;
  final String? imageUrl;
}
