import 'package:flutter/material.dart';

const _galleryImages = [
  'assets/images/0cc804c3-3dc0-4f0b-83a4-db32008223c4.jpg',
  'assets/images/582259684_1332038765286350_952151224765820498_n.jpg',
  'assets/images/5d182f85-ef6d-4051-876d-fee1e40158dc.jpg',
  'assets/images/6d6fb76d-1327-48fc-a876-c8eaee4d2b27.jpg',
  'assets/images/708468294_3035850686606195_2595175600513383110_n.jpg',
  'assets/images/ff99561c-3fe6-408f-889a-b21b0b622c6b.jpg',
];

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: _galleryImages.length,
    itemBuilder: (context, index) {
      final path = _galleryImages[index];
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              child: InteractiveViewer(
                child: Image.asset(path, fit: BoxFit.contain),
              ),
            ),
          ),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            semanticLabel: 'Gallery photo ${index + 1}',
          ),
        ),
      );
    },
  );
}
