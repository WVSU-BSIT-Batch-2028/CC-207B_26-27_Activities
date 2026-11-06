class PickDetails {
  const PickDetails({
    required this.title,
    this.subtitle,
    this.description,
    this.imageUrl,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
}