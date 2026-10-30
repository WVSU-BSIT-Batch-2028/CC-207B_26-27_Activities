class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

// Replace the captions with your own.
const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Caption 1'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'Caption 2'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Caption 3'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Caption 4'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Caption 5'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Caption 6'),
];