import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/my_info.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  bool _isPlaying = false;
  int _playCount = 0;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    try {
      await _player.play(AssetSource(petSound));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not play the sound: $e')));
    }
  }

  void _toggleHeart() => setState(() => _liked = !_liked);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;
    final times = _playCount == 1 ? 'time' : 'times';

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Meet $petName, my $petAnimal!',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onDoubleTap: _toggleHeart,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            petPhoto,
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of my $petAnimal, $petName',
                            errorBuilder: (context, error, stack) =>
                                ColoredBox(
                                  color: colors.secondaryContainer,
                                  child: Icon(
                                    Icons.pets,
                                    size: 96,
                                    color: colors.onSecondaryContainer,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      if (_liked)
                        Icon(
                          Icons.favorite,
                          size: 120,
                          color: colors.error,
                          semanticLabel: 'Liked',
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Double-tap the photo to give $petName a heart.',
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(_isPlaying ? Icons.graphic_eq : Icons.volume_up),
                  label: Text(
                    _isPlaying ? 'Playing...' : "Play $petName's sound",
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  '$petName has $petSoundVerb $_playCount $times.',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
