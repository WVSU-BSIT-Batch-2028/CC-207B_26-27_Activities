/// One recommendation stored in the CMS.
///
/// The CMS keeps the words. The cover, year, and summary come from
/// Open Library or OMDb when the pick is opened.
class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  /// Contentful entry id. Used so the list can tell picks apart.
  final String id;
  final String title;

  /// `book` or `movie`.
  final String kind;

  /// Open Library work id or IMDb id.
  final String externalId;
  final String note;

  bool get isBook => kind == 'book';
  bool get isMovie => kind == 'movie';
}
