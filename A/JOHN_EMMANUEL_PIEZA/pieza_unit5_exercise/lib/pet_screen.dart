import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const String _animalName = 'T Rex';

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
      _playCount++;
    });

    try {
      await _player.play(
        AssetSource('sounds/pet_sound.mp3'),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isPlaying = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to play the sound.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Prehistoric Animal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _animalName,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/trex.png',
                        fit: BoxFit.cover,
                        semanticLabel:
                            'Picture of my favorite prehistoric '
                            'animal, $_animalName',
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.cruelty_free,
                              size: 64,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_isLiked)
                    Icon(
                      Icons.favorite,
                      size: 80,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Double-tap the picture to show some love.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(
                _isPlaying
                    ? Icons.graphic_eq
                    : Icons.volume_up,
              ),
              label: Text(
                _isPlaying ? 'Playing...' : 'Play dinosaur sound',
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$_animalName has made a sound '
                        '$_playCount '
                        '${_playCount == 1 ? 'time' : 'times'}.',
                        style: theme.textTheme.titleMedium,
                      ),
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
