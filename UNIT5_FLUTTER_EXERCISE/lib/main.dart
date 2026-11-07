import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  static const _pink = Color(0xFFF5C8DF);
  static const _yellow = Color(0xFFF7E38A);

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
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
      _barkCount += 1;
    });

    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: [
            _buildProfilePage(),
            _buildPetPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage,
        onDestinationSelected: (index) => setState(() => _selectedPage = index),
        backgroundColor: Colors.white,
        indicatorColor: _pink.withValues(alpha: 0.55),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/myprofile.jpeg',
                  width: 112,
                  height: 132,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daniella\nDayrit',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 29,
                        height: 1.02,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'BS Information Technology',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Antique, Philippines',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: _softSage,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.cake_outlined, size: 18, color: _ink),
                SizedBox(width: 10),
                Text(
                  'BIRTHDAY',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
                Spacer(),
                Text(
                  'March 9, 2006',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _sectionTitle('About me'),
          const SizedBox(height: 12),
          const Text(
            'I’m Daniella, a student from Antique pursuing a Bachelor of Science in Information Technology at West Visayas State University – College of Information and Communications Technology. A STEM honors graduate of Antique National School, I enjoy getting involved in organizations and finding creative ways to learn. I’m working toward my academic goals while making meaningful memories along the way.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.65),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Personal details'),
          const SizedBox(height: 12),
          _detailRow(Icons.email_outlined, 'Email', 'daniella.dayrit@wvsu.edu.ph'),
          _detailRow(Icons.phone_outlined, 'Phone', '09362000895'),
          _detailRow(
            Icons.school_outlined,
            'Education',
            'WVSU – College of Information and Communications Technology',
          ),
          _detailRow(Icons.menu_book_outlined, 'Course', 'BS Information Technology'),
          const SizedBox(height: 22),
          _sectionTitle('A little about me', icon: Icons.auto_awesome_outlined),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _hobbyChip(Icons.mic_none, 'Singing', _pink),
              _hobbyChip(Icons.music_note, 'Dancing', _yellow),
              _hobbyChip(Icons.bedtime_outlined, 'Sleeping', _softSage),
            ],
          ),
          const SizedBox(height: 26),
          InkWell(
            onTap: () => setState(() => _selectedPage = 1),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF3E9DF)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _pink,
                    foregroundColor: _ink,
                    child: Icon(Icons.pets_outlined),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remembering Cookie',
                          style: TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'My beloved fur baby',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: _muted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A place in my heart',
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cookie',
            style: TextStyle(
              color: _ink,
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onDoubleTap: () {
              setState(() => _isLiked = !_isLiked);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: double.infinity,
                    height: 290,
                    color: const Color(0xFFF8F6F1),
                    child: Image.asset(
                      'assets/images/mypet.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (_isLiked)
                  const Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: 68,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _isPlaying ? null : _playSound,
            icon: const Icon(Icons.volume_up_outlined),
            label: Text(_isPlaying ? 'Playing...' : 'Play bark'),
            style: FilledButton.styleFrom(
              backgroundColor: _pink,
              foregroundColor: _ink,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Cookie has barked $_barkCount time${_barkCount == 1 ? '' : 's'}.',
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _pink.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 16, color: _ink),
                SizedBox(width: 8),
                Text(
                  'Forever my beloved fur baby',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('My sweet Cookie'),
          const SizedBox(height: 12),
          const Text(
            'Cookie was a sweet and lovable Aspin who brought so much happiness and love into my life. Cookie was supposed to turn 2 years old and was more than just a pet: Cookie was family, a source of comfort, and a precious companion.',
            style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _softSage,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'July 30',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'The day Cookie passed, and the date I hold close as I remember all the joy we shared.',
                  style: TextStyle(color: _muted, fontSize: 13, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 19, color: _sage),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: _sage),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _ink,
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hobbyChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _ink),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

