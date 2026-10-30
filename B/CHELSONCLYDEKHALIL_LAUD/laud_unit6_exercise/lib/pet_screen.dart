import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _soundCount = 0;
  bool _isLiked = false;

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
    setState(() {
      _isPlaying = true;
      _soundCount++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Future<void> _resetCount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text('Mr. Snuggles has meowed $_soundCount time(s). Reset back to zero?'),
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

    if (confirmed == true) {
      setState(() {
        _soundCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'This is Mr. Snuggles',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onDoubleTap: _toggleLike,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Semantics(
                    label: 'Photo of my pet',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/pet.jpg',
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (_isLiked)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 80,
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About My Cat',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'William Snuggleton Valentin the Third is one of the three stray cats who I found wandering outside our house. Unlike the two other cats who are very sabad, we decided to keep Mr. Snuggles because he is gentle and well-mannered. The way he walks around and stares at us menacingly act like he is the king of our place.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Mr. Snuggles has meowed $_soundCount times.',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play Meow Sound'),
            ),
            const SizedBox(height: 8),

            OutlinedButton(
              onPressed: _soundCount == 0 ? null : _resetCount,
              child: const Text('Reset count'),
            ),
          ],
        ),
      ),
    );
  }
}