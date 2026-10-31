import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Nherie C. Acebuche - Profile & Pet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomeShell(),
      );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  // IndexedStack preserves state while a different tab is visible.
  final _screens = const [ProfileScreen(), PetScreen(), GalleryScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'My Pet'),
            NavigationDestination(icon: Icon(Icons.photo_outlined), selectedIcon: Icon(Icons.photo), label: 'Gallery'),
          ],
        ),
      );
}

class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;
  const ProfileInfo(this.icon, this.label, this.value);
}

class ClassSlot {
  final String day;
  final String time;
  final String subject;
  const ClassSlot(this.day, this.time, this.subject);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const _information = [
    ProfileInfo(Icons.school_outlined, 'Program & Year Level', 'BS Information Technology - 3rd Year'),
    ProfileInfo(Icons.account_balance_outlined, 'School', 'West Visayas State University - Main Campus'),
    ProfileInfo(Icons.email_outlined, 'Email', 'nherie.acebuche@wvsu.edu.ph'),
    ProfileInfo(Icons.code_outlined, 'Programming Languages', 'Java, HTML, CSS, JS, React, PHP, MySQL'),
    ProfileInfo(Icons.brush_outlined, 'Creative Skills', 'Charcoal Painting, Drawing, Animation, Character Design'),
    ProfileInfo(Icons.lightbulb_outline, 'Technical Interests', 'Software Development, Project Management, Systems Analysis'),
    ProfileInfo(Icons.format_quote_outlined, 'Motto in Life', 'Creare. Crescere. Audere. (To create. To grow. To dare.)'),
  ];
  static const _hobbies = ['Charcoal Painting', 'Drawing', 'Gardening', 'Volleyball', 'Animation'];
  static const _classes = [
    ClassSlot('Monday', '7:00-9:00 AM\nICT 106', 'CIT 213 - Human Computer Interaction 2'),
    ClassSlot('Monday', '9:00 AM-12:00 PM\nICT 307', 'CIT 246 - IT Project Management'),
    ClassSlot('Monday', '1:00-3:00 PM\nICT 307', 'CIT 210 - Web Systems and Technologies'),
    ClassSlot('Tuesday', '9:00 AM-12:00 PM\nICT 307', 'CC 207B - Applications Development and Emerging Technologies'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nherie C. Acebuche'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            ClipOval(child: Image.asset('assets/images/nherie.png', width: 96, height: 96, fit: BoxFit.cover, semanticLabel: 'Photo of Nherie C. Acebuche')),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nherie C. Acebuche', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Create with imagination, grow with patience, and discover with courage.'),
            ])),
          ]),
          const SizedBox(height: 20),
          Text('Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          AppCard(child: Column(children: [for (final item in _information) InfoTile(item)])),
          const SizedBox(height: 16),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('My Hobbies', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final hobby in _hobbies) Chip(label: Text(hobby))]),
          ])),
          const SizedBox(height: 16),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('My Class Schedule', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: theme.colorScheme.outlineVariant),
              columnWidths: const {0: FixedColumnWidth(82), 1: FixedColumnWidth(110), 2: FlexColumnWidth()},
              children: [
                TableRow(decoration: BoxDecoration(color: theme.colorScheme.primaryContainer), children: const [TableHeader('Day'), TableHeader('Time'), TableHeader('Subject')]),
                for (final slot in _classes) TableRow(children: [TableCellText(slot.day), TableCellText(slot.time), TableCellText(slot.subject)]),
              ],
            ),
          ])),
          const SizedBox(height: 16),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('My Biography', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('I am Nherie C. Acebuche, a Bachelor of Science in Information Technology student at West Visayas State University - Main Campus. I enjoy exploring creativity and technology through drawing, gardening, and software development. I believe growth is a continuous journey of learning, creating, and discovering.'),
          ])),
        ]),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      );
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;
  const InfoTile(this.info, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(info.icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(info.label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(info.value),
          ])),
        ]),
      );
}

class TableHeader extends StatelessWidget {
  final String text;
  const TableHeader(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
}

class TableCellText extends StatelessWidget {
  final String text;
  const TableCellText(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(8), child: Text(text));
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});
  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _hasHeart = false;
  int _barkCount = 0;
  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) { if (mounted) setState(() => _isPlaying = false); });
  }
  @override
  void dispose() { _player.dispose(); super.dispose(); }
  Future<void> _playSound() async {
    setState(() { _isPlaying = true; _barkCount++; });
    try { await _player.play(AssetSource('sounds/pet_sound.wav')); } catch (_) { if (mounted) setState(() => _isPlaying = false); }
  }
  Future<void> _confirmReset() async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('Do you want to reset Chocho\'s bark count to zero?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Reset')),
        ],
      ),
    );
    if (answer == true && mounted) setState(() => _barkCount = 0);
  }
  @override
  Widget build(BuildContext context) {
    final countText = _barkCount == 1 ? 'Chocho has barked 1 time.' : 'Chocho has barked $_barkCount times.';
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Text('Chocho', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          GestureDetector(
            onDoubleTap: () => setState(() => _hasHeart = !_hasHeart),
            child: Stack(alignment: Alignment.center, children: [
              ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/chocho.jpg', height: 340, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Photo of Chocho the dog')),
              if (_hasHeart) Icon(Icons.favorite, size: 72, color: Theme.of(context).colorScheme.error),
            ]),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: _isPlaying ? null : _playSound, icon: Icon(_isPlaying ? Icons.volume_up : Icons.music_note), label: Text(_isPlaying ? 'Playing...' : 'Hear Chocho Bark')),
          const SizedBox(height: 16),
          Text(countText),
          OutlinedButton(onPressed: _barkCount == 0 ? null : _confirmReset, child: const Text('Reset count')),
        ]),
      ),
    );
  }
}

class Photo {
  final String asset;
  final String caption;
  const Photo({required this.asset, required this.caption});
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const _photos = [
    Photo(asset: 'assets/images/gallery/charcoal_contest.jpg', caption: 'My 1st Charcoal Painting Contest'),
    Photo(asset: 'assets/images/gallery/meal_memory.jpg', caption: 'A meal with him after months of LDR #UmuwiKanaBaby'),
    Photo(asset: 'assets/images/gallery/bride_drawing.jpg', caption: 'The Corpse Bride'),
    Photo(asset: 'assets/images/gallery/thanos_drawing.jpg', caption: 'Thanos portrait drawing'),
    Photo(asset: 'assets/images/gallery/gardening.jpg', caption: 'Gardening'),
    Photo(asset: 'assets/images/gallery/siblings.jpg', caption: 'Celebration with siblings'),
    Photo(asset: 'assets/images/gallery/family_beach.jpg', caption: 'Family beach holiday'),
    Photo(asset: 'assets/images/gallery/graduation_memory.jpg', caption: 'TUSKP since HS'),
    Photo(asset: 'assets/images/gallery/school_friends.jpg', caption: 'His into Her'),
    Photo(asset: 'assets/images/gallery/okra_blossom.jpg', caption: 'Okra blossom'),
    Photo(asset: 'assets/images/gallery/volleyball_team.jpg', caption: 'RADEON VB Team Fundays 2k26'),
  ];
  String? _favoriteAsset;
  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)));
    if (makeFavorite == true && mounted) setState(() => _favoriteAsset = photo.asset);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Gallery'), centerTitle: true),
        body: GridView.extent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          children: [
            for (final photo in _photos)
              InkWell(
                key: ValueKey('gallery-${photo.asset}'),
                onTap: () => _open(photo),
                child: Stack(fit: StackFit.expand, children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(photo.asset, fit: BoxFit.cover, semanticLabel: photo.caption)),
                  if (_favoriteAsset == photo.asset) const Positioned(top: 6, right: 6, child: Icon(Icons.star, color: Colors.amber, size: 32)),
                ]),
              ),
          ],
        ),
      );
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(photo.caption)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(photo.asset, fit: BoxFit.contain, semanticLabel: photo.caption))),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Make favorite')),
          ]),
        ),
      );
}
