import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daniella Dayrit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9EAD6D),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const ProfileHomePage(),
    );
  }
}

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  int _selectedPage = 0;
  bool _isPlaying = false;
  bool _isLiked = false;
  int _barkCount = 0;
  final AudioPlayer _player = AudioPlayer();

  static const _ink = Color(0xFF25251F);
  static const _muted = Color(0xFF77776F);
  static const _sage = Color(0xFF9EAD6D);
  static const _softSage = Color(0xFFF1F4E9);

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
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });
    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _resetCount() async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('This will set Cookie\'s bark count back to zero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (reset == true && mounted) setState(() => _barkCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildProfilePage(), _buildPetPage(), const GalleryScreen()];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedPage, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage,
        onDestinationSelected: (index) => setState(() => _selectedPage = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'My profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Cookie',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset('assets/images/myprofile.jpeg', width: 112, height: 132, fit: BoxFit.cover),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daniella\nDayrit', style: TextStyle(color: _ink, fontSize: 29, height: 1.02, fontWeight: FontWeight.w700)),
                    SizedBox(height: 12),
                    Text('BS Information Technology', style: TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Antique, Philippines', style: TextStyle(color: _muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _infoBanner(),
          const SizedBox(height: 26),
          _sectionTitle('About me'),
          const SizedBox(height: 12),
          const Text(
            'I’m Daniella, a student from Antique pursuing a Bachelor of Science in Information Technology at West Visayas State University – College of Information and Communications Technology. I enjoy getting involved in organizations and finding creative ways to learn.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.65),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Personal details'),
          const SizedBox(height: 12),
          _detailRow(Icons.email_outlined, 'Email', 'daniella.dayrit@wvsu.edu.ph'),
          _detailRow(Icons.phone_outlined, 'Phone', '09362000895'),
          _detailRow(Icons.school_outlined, 'Education', 'WVSU – College of Information and Communications Technology'),
          _detailRow(Icons.menu_book_outlined, 'Course', 'BS Information Technology'),
          const SizedBox(height: 18),
          _hobbiesCard(),
          const SizedBox(height: 18),
          _scheduleCard(),
        ],
      ),
    );
  }

  Widget _infoBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: _softSage, borderRadius: BorderRadius.circular(16)),
        child: const Row(
          children: [
            Icon(Icons.cake_outlined, size: 18, color: _ink),
            SizedBox(width: 10),
            Text('BIRTHDAY', style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .7)),
            Spacer(),
            Text('March 9, 2006', style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _hobbiesCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('My Hobbies', icon: Icons.auto_awesome_outlined),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(avatar: Icon(Icons.mic_none), label: Text('Singing')),
                  Chip(avatar: Icon(Icons.music_note), label: Text('Dancing')),
                  Chip(avatar: Icon(Icons.bedtime_outlined), label: Text('Sleeping')),
                  Chip(avatar: Icon(Icons.camera_alt_outlined), label: Text('Photography')),
                  Chip(avatar: Icon(Icons.menu_book), label: Text('Reading')),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _scheduleCard() {
    const slots = [
      ClassSlot('Monday', '8:00 AM', 'Mobile App Development'),
      ClassSlot('Tuesday', '10:00 AM', 'Database Management'),
      ClassSlot('Wednesday', '1:00 PM', 'Web Systems and Technologies'),
      ClassSlot('Thursday', '3:00 PM', 'Information Assurance'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('My Class Schedule', icon: Icons.calendar_month_outlined),
            const SizedBox(height: 14),
            Table(
              border: TableBorder.all(color: Colors.black12),
              columnWidths: const {0: FixedColumnWidth(78), 1: FixedColumnWidth(78), 2: FlexColumnWidth()},
              children: [
                _scheduleRow('Day', 'Time', 'Subject', header: true),
                for (final slot in slots) _scheduleRow(slot.day, slot.time, slot.subject),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _scheduleRow(String day, String time, String subject, {bool header = false}) => TableRow(
        decoration: header ? BoxDecoration(color: ThemeData().colorScheme.primaryContainer) : null,
        children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(day, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
          Padding(padding: const EdgeInsets.all(8), child: Text(time, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
          Padding(padding: const EdgeInsets.all(8), child: Text(subject, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
        ],
      );

  Widget _buildPetPage() => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A place in my heart', style: TextStyle(color: _muted, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Cookie', style: TextStyle(color: _ink, fontSize: 34, fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(width: double.infinity, height: 290, color: const Color(0xFFF8F6F1), child: Image.asset('assets/images/mypet.png', fit: BoxFit.contain)),
                  ),
                  if (_isLiked) const Icon(Icons.favorite, color: Colors.pink, size: 68),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: _isPlaying ? null : _playSound, icon: const Icon(Icons.volume_up_outlined), label: Text(_isPlaying ? 'Playing...' : 'Play bark')),
            const SizedBox(height: 14),
            Text('Cookie has barked $_barkCount time${_barkCount == 1 ? '' : 's'}.', style: const TextStyle(color: _ink, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _barkCount == 0 ? null : _resetCount,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset count'),
            ),
            const SizedBox(height: 22),
            _sectionTitle('My sweet Cookie'),
            const SizedBox(height: 12),
            const Text('Cookie was a sweet and lovable Aspin who brought so much happiness and love into my life. Cookie was more than just a pet: Cookie was family, a source of comfort, and a precious companion.', style: TextStyle(color: _muted, fontSize: 14, height: 1.7)),
          ],
        ),
      );

  Widget _sectionTitle(String title, {IconData? icon}) => Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 19, color: _sage), const SizedBox(width: 8)],
          Text(title, style: const TextStyle(color: _ink, fontSize: 19, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _detailRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 19, color: _sage),
            const SizedBox(width: 12),
            SizedBox(width: 76, child: Text(label, style: const TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(child: Text(value, style: const TextStyle(color: _ink, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500))),
          ],
        ),
      );
}

class Photo {
  const Photo({required this.asset, required this.caption});
  final String asset;
  final String caption;
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const photos = [
    Photo(asset: 'assets/images/gallery/beach.jpeg', caption: 'Beach day'),
    Photo(asset: 'assets/images/gallery/cafe.jpeg', caption: 'Cafe memory'),
    Photo(asset: 'assets/images/gallery/cookie.png', caption: 'Cookie'),
    Photo(asset: 'assets/images/gallery/firstdogs.jpeg', caption: 'My first dogs'),
    Photo(asset: 'assets/images/gallery/parangal.jpeg', caption: 'Parangal'),
    Photo(asset: 'assets/images/gallery/profile.jpeg', caption: 'My profile'),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(photo.asset, fit: BoxFit.cover, semanticLabel: photo.caption),
                  ),
                  if (_favoriteAsset == photo.asset)
                    const Positioned(top: 8, right: 8, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.star, color: Colors.amber))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});
  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Center(child: Image.asset(photo.asset, fit: BoxFit.contain, semanticLabel: photo.caption))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pop(context, true), icon: const Icon(Icons.star), label: const Text('Make favorite'))),
          ],
        ),
      ),
    );
  }
}

class ClassSlot {
  const ClassSlot(this.day, this.time, this.subject);
  final String day;
  final String time;
  final String subject;
}
