class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/gallery/1.png', caption: 'Pink Blossom'),
  Photo(asset: 'assets/gallery/2.png', caption: 'Lily Bloom'),
  Photo(asset: 'assets/gallery/3.png', caption: 'Orchid Petal'),
  Photo(asset: 'assets/gallery/4.png', caption: 'Gerbera Daisy'),
  Photo(asset: 'assets/gallery/5.png', caption: 'Petal Dew'),
  Photo(asset: 'assets/gallery/6.png', caption: 'Lotus Flower'),
];