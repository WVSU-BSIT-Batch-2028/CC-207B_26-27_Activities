class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> galleryPhotos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'SHET! mga ninong???',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'di mo na ko lab? :((',
  ),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'kunyare cute'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'taena ang ganda'),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'with hindi ko kilala',
  ),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'ka miss :(('),
];
