/// What the API knows about a pick (the CMS only stores the ID and my note).
class PickDetails {
  const PickDetails({
    required this.title,
    required this.summary,
    this.imageUrl,
    this.year,
  });

  final String title;
  final String summary;
  final String? imageUrl;
  final String? year;
}