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
  int _barkCount = 0;
  bool _showHeart = false;

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
      _barkCount++;
    });
    try {
      await _player.play(AssetSource('sounds/puppy_bark.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  void _toggleHeart() {
    setState(() {
      _showHeart = !_showHeart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: _toggleHeart,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        'assets/images/puppy.png',
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of Whitey',
                        width: double.infinity,
                        height: 320.0,
                      ),
                    ),
                  ),
                  if (_showHeart)
                    Icon(Icons.favorite, color: colorScheme.error, size: 90.0),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play Puppy Sound'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Whitey has barked $_barkCount ${_barkCount == 1 ? 'time' : 'times'}.',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
