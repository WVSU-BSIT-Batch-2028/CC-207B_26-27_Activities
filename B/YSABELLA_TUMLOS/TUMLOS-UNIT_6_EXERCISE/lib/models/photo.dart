import 'package:flutter/painting.dart';

class Photo {
  const Photo({
    required this.asset,
    required this.caption,
    this.alignment = Alignment.center,
    this.thumbnail,
  });

  final String asset;
  final String caption;
  final Alignment alignment;
  final String? thumbnail;
}

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/gallery_01.jpg',
    caption: 'I look pretty good at night hehe',
    alignment: Alignment(0, 0.25),
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_02.jpg',
    caption: 'yes, we finished all that food',
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_03.jpg',
    caption: 'Photo booth',
    thumbnail: 'assets/images/gallery/thumb_03.jpg',
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_04.jpg',
    caption: 'happy 2 years up in the rooftop restaurant',
    alignment: Alignment(0, 0.4),
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_05.jpg',
    caption: 'pretty flowers hehe',
    thumbnail: 'assets/images/gallery/thumb_05.jpg',
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_06.jpg',
    caption: 'very Minor days',
    alignment: Alignment(0, -0.7),
  ),
];
