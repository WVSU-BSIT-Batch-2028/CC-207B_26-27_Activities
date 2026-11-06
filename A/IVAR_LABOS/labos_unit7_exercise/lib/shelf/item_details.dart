/// What a pick's detail screen shows, whichever API it came from.
class ItemDetails {
  const ItemDetails({
    required this.title,
    required this.summary,
    this.subtitle,
    this.imageUrl,
  });

  final String title;
  final String summary;
  final String? subtitle;
  final String? imageUrl;
}
