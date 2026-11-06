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
  bool _liked = false;
  int _barkCount = 0;

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
      _barkCount++;
    });
    // AssetSource looks inside the assets/ folder
    await _player.play(AssetSource('sounds/dog_bark.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _liked = !_liked),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/SREIT.jpg',
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Sreit, my dog',
                    ),
                  ),
                  if (_liked)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Icon(Icons.favorite, size: 48, color: colors.error),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Sreit', style: textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Sreit has barked $_barkCount times.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play bark'),
            ),
          ],
        ),
      ),
    );
  }
}