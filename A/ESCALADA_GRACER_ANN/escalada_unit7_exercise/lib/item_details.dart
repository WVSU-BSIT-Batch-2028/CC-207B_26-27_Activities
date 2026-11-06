class ItemDetails {
  final String title;
  final String? imageUrl;
  final String summary;

  const ItemDetails({
    required this.title,
    this.imageUrl,
    required this.summary,
  });
}