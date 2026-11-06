class MediaDetails {
  const MediaDetails({
    required this.title,
    required this.year,
    required this.summary,
    required this.artworkUrl,
  });

  final String title;
  final String year;
  final String summary;
  final String? artworkUrl;
}
