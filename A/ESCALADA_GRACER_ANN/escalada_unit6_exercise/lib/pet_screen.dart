import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    await _player.play(AssetSource('sounds/catmeow.mp3'));
  }

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text('The cat has meowed $_playCount times. Do you want to reset the count back to 0?'),
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
    if (answer == true) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/cat1.jpg',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                  if (_isLiked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 16),
            Text(
              'My pet has made a sound $_playCount times.',
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _playCount == 0 ? null : _confirmReset,
              child: const Text('Reset count'),
            ),
          ],
        ),
      ),
    );
  }
}