import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../widgets/centered_scroll.dart';
import '../widgets/glass_bar_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_chip.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/glass_title.dart';

const String petName = 'Biscoff';
const String petVerb = 'barked';
const String petPhoto = 'assets/images/biscoff.jpeg';
const String petSound = 'sounds/pet_sound.mp3';

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
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _toggleLike() => setState(() => _isLiked = !_isLiked);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GlassTitle('My Pet'),
        flexibleSpace: const GlassBarBackground(),
      ),
      body: CenteredScroll(
        maxWidth: 600,
        child: GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: _toggleLike,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.asset(
                          petPhoto,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of $petName',
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 12,
                      bottom: 12,
                      child: GlassChip(icon: Icons.pets, label: petName),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: GlassIconButton(
                        icon: _isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        tooltip: 'Like',
                        onPressed: _toggleLike,
                      ),
                    ),
                    AnimatedScale(
                      scale: _isLiked ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 96,
                        color: scheme.error,
                        shadows: [
                          Shadow(
                            blurRadius: 16,
                            color: scheme.shadow.withValues(alpha: 0.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Double-tap the photo to show some love',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              GlassChip(
                icon: Icons.graphic_eq_rounded,
                label: '$petName has $petVerb $_playCount '
                    '${_playCount == 1 ? 'time' : 'times'}.',
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(_isPlaying
                      ? Icons.graphic_eq_rounded
                      : Icons.volume_up_rounded),
                  label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
