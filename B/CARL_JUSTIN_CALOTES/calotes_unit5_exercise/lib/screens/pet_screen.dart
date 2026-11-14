import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _playPetSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _audioPlayer.play(
        AssetSource('sounds/Murata_sound.mp3'),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play Murata’s sound.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _showHeart = !_showHeart;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/Murata.jpg',
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Murata the cat',
                    ),
                  ),
                  if (_showHeart)
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 80,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Murata',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'My Son',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playPetSound,
              icon: const Icon(Icons.volume_up),
              label: Text(
                _isPlaying
                    ? 'Playing...'
                    : 'Play Murata’s Sound',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Murata meowed: $_playCount time(s)',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Secret: Double-tap the photo for a surprise!',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
