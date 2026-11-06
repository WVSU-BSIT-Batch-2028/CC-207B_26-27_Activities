class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/bebe.JPG', caption: 'bebe'),
  Photo(asset: 'assets/images/gallery/em.JPG', caption: 'em'),
  Photo(asset: 'assets/images/gallery/fam.JPEG', caption: 'fam'),
  Photo(asset: 'assets/images/gallery/gletimeo.JPG', caption: 'gletimeo',),
  Photo(asset: 'assets/images/gallery/jah.JPG', caption: 'jah'),
  Photo(asset: 'assets/images/gallery/sreit.jpg', caption: 'sreit'),
];