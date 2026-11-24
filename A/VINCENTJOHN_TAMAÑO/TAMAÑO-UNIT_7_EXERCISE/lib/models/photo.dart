class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> samplePhotos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'Cybersecurity Lab',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'WVSU Campus Tour',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'Hackathon Team',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'Mallows the Cat',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'Weekend Fishing',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'Mobile Dev Project',
  ),
];

