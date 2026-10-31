import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// TODO: change these to your pet's details. No pet? Use a favorite animal
// and set [petIsFavoriteAnimal] to true so the screen says so.
const String petName = 'Luna';
const String petSoundVerb = 'barked';
const bool petIsFavoriteAnimal = false;

const String petImageAsset = 'assets/images/pet.jpg';
// AssetSource looks inside the assets/ folder, so no "assets/" prefix here.
const String petSoundAsset = 'sounds/pet_sound.mp3';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  // Created once, released in dispose().
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLiked = false;
  int _soundCount = 0;

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
      _soundCount++;
    });
    try {
      await _player.play(AssetSource(petSoundAsset));
    } catch (_) {
      // If the sound could not start, re-enable the button.
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timesLabel = _soundCount == 1 ? 'time' : 'times';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(petName, style: theme.textTheme.headlineSmall),
            if (petIsFavoriteAnimal)
              Text(
                'I do not have a pet, so this is my favorite animal.',
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 12),

            // Large photo: double-tap toggles a heart on top (GestureDetector + Stack).
            GestureDetector(
              onDoubleTap: _toggleLike,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        petImageAsset,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of my pet $petName',
                      ),
                      Center(
                        child: AnimatedOpacity(
                          opacity: _isLiked ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.favorite,
                            size: 96,
                            color: theme.colorScheme.error,
                            semanticLabel: 'Liked',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to show some love.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Sound button: disabled while playing.
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.pets),
              label: Text(_isPlaying ? 'Playing...' : 'Hear $petName'),
            ),
            const SizedBox(height: 12),

            // Counter: goes up on every play.
            Text(
              '$petName has $petSoundVerb $_soundCount $timesLabel.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
