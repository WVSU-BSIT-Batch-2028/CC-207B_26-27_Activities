import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceContainerHighest: Color(0xFFF1F1F1),
    outline: Colors.black,
    outlineVariant: Color(0xFFD9D9D9),
    error: Color(0xFFE53935), 
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surfaceContainerHighest,
    fontFamily: 'Courier New',
    fontFamilyFallback: const ['Courier', 'monospace'],
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w800, fontSize: 26),
      titleLarge: TextStyle(fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontWeight: FontWeight.w700),
      labelLarge: TextStyle(fontWeight: FontWeight.w800),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      titleTextStyle: TextStyle(
        color: scheme.onPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 20,
        letterSpacing: 1,
        fontFamily: 'Courier New',
        fontFamilyFallback: const ['Courier', 'monospace'],
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outline, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      side: BorderSide(color: scheme.outline, width: 1.5),
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: scheme.outline, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary,
      elevation: 0,
      height: 72,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.onSurface,
        );
      }),
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeShell(),
    );
  }
}

class PeekingCat extends StatelessWidget {
  final Color bodyColor;
  final Color eyeColor;
  final Color pupilColor;
  final double width;

  const PeekingCat({
    super.key,
    required this.bodyColor,
    required this.eyeColor,
    required this.pupilColor,
    this.width = 110,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRect(
        child: CustomPaint(
          size: Size(width, width * 0.6),
          painter: _CatPainter(
            bodyColor: bodyColor,
            eyeColor: eyeColor,
            pupilColor: pupilColor,
          ),
        ),
      ),
    );
  }
}

class _CatPainter extends CustomPainter {
  final Color bodyColor;
  final Color eyeColor;
  final Color pupilColor;

  const _CatPainter({
    required this.bodyColor,
    required this.eyeColor,
    required this.pupilColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = Paint()..color = bodyColor;

    canvas.drawOval(Rect.fromLTWH(w * 0.05, h * 0.3, w * 0.9, h * 1.4), body);

    final leftEar = Path()
      ..moveTo(w * 0.12, h * 0.6)
      ..lineTo(w * 0.14, h * 0.02)
      ..lineTo(w * 0.42, h * 0.36)
      ..close();
    final rightEar = Path()
      ..moveTo(w * 0.88, h * 0.6)
      ..lineTo(w * 0.86, h * 0.02)
      ..lineTo(w * 0.58, h * 0.36)
      ..close();
    canvas.drawPath(leftEar, body);
    canvas.drawPath(rightEar, body);

    final eye = Paint()..color = eyeColor;
    final pupil = Paint()..color = pupilColor;
    for (final dx in [0.33, 0.67]) {
      final c = Offset(w * dx, h * 0.7);
      canvas.drawCircle(c, w * 0.115, eye);
      canvas.drawCircle(c, w * 0.065, pupil);
    }
  }

  @override
  bool shouldRepaint(covariant _CatPainter old) =>
      old.bodyColor != bodyColor ||
      old.eyeColor != eyeColor ||
      old.pupilColor != pupilColor;
}

class BrandTitle extends StatelessWidget {
  final String title;

  const BrandTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget eye() => Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: scheme.onPrimary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [eye(), const SizedBox(width: 4), eye()],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class PageBody extends StatelessWidget {
  final Widget child;

  const PageBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(info.icon, color: scheme.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(info.value, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<ProfileInfo> infos = [
      const ProfileInfo(icon: Icons.cake, label: "Birthdate", value: "May 23, 2006"),
      const ProfileInfo(icon: Icons.location_on, label: "Address", value: "Tubungan, Iloilo, Philippines"),
      const ProfileInfo(icon: Icons.music_note, label: "Favorite Song", value: "Heaven and Back"),
      const ProfileInfo(icon: Icons.movie, label: "Favorite Movie", value: "Dune"),
      const ProfileInfo(icon: Icons.school, label: "Education", value: "West Visayas State University"),
      const ProfileInfo(icon: Icons.book, label: "Course", value: "Bachelor of Science in Information Technology"),
    ];

    const List<String> hobbies = [
      "Tabletop Gaming",
      "Watching Movies",
      "Drawing",
      "Listening to Music",
      "Sleeping",
      "Cooking",
    ];

    const List<ClassSlot> schedule = [
      ClassSlot(day: "Mon", time: "7:00-9:00", subject: "Human Computer Interaction 2"),
      ClassSlot(day: "Tue", time: "9:00-12:00", subject: "Applications Development and Emerging Technologies"),
      ClassSlot(day: "Wed", time: "10:00-12:00", subject: "IT Project Management"),
      ClassSlot(day: "Thu", time: "1:00-2:30", subject: "Technopreneurship"),
    ];

    Widget cell(String text, TextStyle? style) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Text(text, style: style),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const BrandTitle("Ellen Mae Tacleon"),
      ),
      body: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: scheme.outline, width: 2),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.primary, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/me.jpe',
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Ellen Mae Tacleon',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ellen Mae Tacleon',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Hello! Welcome to my little corner',
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PeekingCat(
                      bodyColor: scheme.primary,
                      eyeColor: scheme.surface,
                      pupilColor: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('My Background', style: textTheme.titleMedium),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'My Class Schedule',
                        style: textTheme.titleLarge,
                      ),
                    ),
                    Table(
                      border: TableBorder.all(
                        color: scheme.outline,
                        width: 1.5,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(56),
                        1: FixedColumnWidth(100),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: scheme.primary),
                          children: [
                            for (final title in ['Day', 'Time', 'Subject'])
                              cell(
                                title,
                                textTheme.labelLarge
                                    ?.copyWith(color: scheme.onPrimary),
                              ),
                          ],
                        ),
                        for (final slot in schedule)
                          TableRow(
                            children: [
                              cell(slot.day, textTheme.bodyMedium),
                              cell(slot.time, textTheme.bodyMedium),
                              cell(slot.subject, textTheme.bodyMedium),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              color: scheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: textTheme.titleLarge
                          ?.copyWith(color: scheme.onPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'I am Ellen, a third-year Information Technology student from West Visayas State University with a passion for creativity and continuous learning. In my free time, I enjoy drawing, watching movies, and playing tabletop games, which allow me to explore new ideas, appreciate different perspectives, and express my creativity. I value opportunities to develop my skills, gain new experiences, and grow both personally and academically as I continue my journey in the field of Information Technology.',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: scheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _barkCount = 0;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });
    await _player.play(AssetSource('sounds/catmeow.wav'));
  }

  void _toggleHeart() {
    setState(() {
      _showHeart = !_showHeart;
    });
  }

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text(
          'Baka has meowed $_barkCount times. Start over from 0?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (answer == true && mounted) {
      setState(() {
        _barkCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const BrandTitle("My Pet")),
      body: PageBody(
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: _toggleHeart,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: scheme.outline, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cat1.jpg',
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of my pet',
                      ),
                      if (_showHeart)
                        Icon(
                          Icons.favorite,
                          color: scheme.error,
                          size: 80,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to send Baka some love',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.onPrimary,
                      foregroundColor: scheme.primary,
                      disabledBackgroundColor:
                          scheme.onPrimary.withValues(alpha: 0.35),
                      disabledForegroundColor: scheme.primary,
                    ),
                    onPressed: _isPlaying ? null : _playSound,
                    icon: const Icon(Icons.volume_up),
                    label: Text(_isPlaying ? "Playing..." : "Play Pet Sound"),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Baka has meowed $_barkCount times.",
                    style: textTheme.titleMedium
                        ?.copyWith(color: scheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.onPrimary,
                      disabledForegroundColor:
                          scheme.onPrimary.withValues(alpha: 0.4),
                      side: BorderSide(
                        color: _barkCount == 0
                            ? scheme.onPrimary.withValues(alpha: 0.4)
                            : scheme.onPrimary,
                        width: 2,
                      ),
                    ),
                    onPressed: _barkCount == 0 ? null : _confirmReset,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text("Reset count"),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PeekingCat(
                      bodyColor: scheme.onPrimary,
                      eyeColor: scheme.primary,
                      pupilColor: scheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Little me'),
  Photo(asset: 'assets/images/gallery/photo2.jpe', caption: 'Hiking'),
  Photo(asset: 'assets/images/gallery/photo3.jpe', caption: 'Starting 2025'),
  Photo(asset: 'assets/images/gallery/photo4.jpe', caption: 'A little trip to the museum'),
  Photo(asset: 'assets/images/gallery/photo5.jpe', caption: 'Random photo'),
  Photo(asset: 'assets/images/gallery/photo7.jpg', caption: 'Sleep, eat, repeat'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
   
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true && mounted) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const BrandTitle("Gallery")),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
            GestureDetector(
              onTap: () => _open(photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                    
                    if (photo.asset == _favoriteAsset)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: scheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: BrandTitle(photo.caption)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: scheme.outline, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          photo.asset,
                          fit: BoxFit.cover,
                          semanticLabel: photo.caption,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    // Pops back with true -> the grid saves the favorite
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.star),
                    label: const Text("Make favorite"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}