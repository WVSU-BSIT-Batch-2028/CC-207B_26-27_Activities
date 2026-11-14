import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const String petName = 'Summer';
const String petPhoto = 'assets/images/summer1.jpg';
const String petPhotoAlt = 'assets/images/summer2.jpg';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {

  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<void> _completeSub;

  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _completeSub = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completeSub.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    try {
      await _player.play(AssetSource('sounds/bark.mp3'));
    } catch (e) {
      debugPrint('Could not play sound: $e');
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onDoubleTap: () => setState(() => _isLiked = !_isLiked),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: SizedBox.expand(
                              key: ValueKey(_isLiked),
                              child: Image.asset(
                                _isLiked ? petPhotoAlt : petPhoto,
                                fit: BoxFit.cover,
                                semanticLabel: _isLiked
                                    ? 'Second photo of $petName, my pet'
                                    : 'Photo of $petName, my pet',
                                errorBuilder: (context, error, stackTrace) => Container(
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
                          if (_isLiked)
                            Center(
                              child: Icon(
                                Icons.favorite,
                                size: 96,
                                color: colors.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Double-tap to pet summer >.<',
                    style: textTheme.bodySmall),
                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.pets),
                  label: Text(_isPlaying ? 'Playing...' : 'Make $petName bark'),
                ),
                const SizedBox(height: 16),

                Text(
                  '$petName has barked $_playCount '
                  '${_playCount == 1 ? 'time' : 'times'}.',
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}