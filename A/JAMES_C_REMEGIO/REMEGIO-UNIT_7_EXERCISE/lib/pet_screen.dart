import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'motion.dart';
import 'robot_beep_path.dart';

/// Wording for Byte's beep counter. One beep uses the singular form.
String beepCountLabel(int count) {
  if (count == 1) {
    return 'Byte has beeped 1 time';
  }
  return 'Byte has beeped $count times';
}

/// Asks before clearing Byte's beep count.
///
/// Cancel pops `false`. Reset pops `true`.
class ResetCountDialog extends StatelessWidget {
  const ResetCountDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset the count?'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(72, 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

const String _byteAsset = 'assets/images/robot_head_both_eyes.png';
const String _soundBundleKey = 'assets/sounds/robot_beep.mp3';
const String _byteLabel = 'Byte, a blue pixel-art robot';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  static const Key portraitKey = Key('byte-portrait');
  static const Key heartKey = Key('byte-heart');

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  bool _showHeart = false;
  bool _isPlaying = false;
  bool _hasBeepSource = false;
  int _beepCount = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (!mounted) {
        return;
      }
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _toggleHeart() {
    setState(() => _showHeart = !_showHeart);
  }

  /// Clears the counter only when Reset returns true.
  ///
  /// Cancel, and dismissing the dialog, both leave the count unchanged.
  Future<void> _confirmReset() async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ResetCountDialog(
          message: '${beepCountLabel(_beepCount)}. Start again from zero?',
        );
      },
    );
    if (reset != true || !mounted) {
      return;
    }
    setState(() => _beepCount = 0);
  }

  Future<void> _playBeep() async {
    if (_isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = true;
      _errorMessage = null;
    });

    try {
      await rootBundle.load(_soundBundleKey);
      if (_hasBeepSource) {
        await _player.stop();
      }
      await _player.setReleaseMode(ReleaseMode.stop);
      final String? bundledBeep = bundledRobotBeepPath();
      final Source beep = bundledBeep == null
          ? AssetSource('sounds/robot_beep.mp3')
          : DeviceFileSource(bundledBeep, mimeType: 'audio/mpeg');
      await _player.play(beep);
      _hasBeepSource = true;
      if (!mounted) {
        return;
      }
      setState(() => _beepCount += 1);
    } catch (error) {
      debugPrint('Byte beep failed for $_soundBundleKey: $error');
      if (!mounted) {
        return;
      }
      const String message =
          'Byte could not play assets/sounds/robot_beep.mp3. Try again.';
      setState(() {
        _isPlaying = false;
        _errorMessage = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bool canReset = _beepCount > 0 && !_isPlaying;

    return Scaffold(
      appBar: AppBar(title: const Text('Byte')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Meet Byte',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hi, I\'m Byte. I\'m a little blue robot, and I saved you a beep.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      final double available = math.max(
                        0,
                        constraints.maxWidth,
                      );
                      final double preferred = math.min(
                        420,
                        MediaQuery.sizeOf(context).height * 0.46,
                      );
                      final double side = math.min(
                        available,
                        math.max(140, preferred),
                      );
                      return Align(
                        alignment: Alignment.center,
                        child: _BytePortrait(
                          side: side,
                          showHeart: _showHeart,
                          onDoubleTap: _toggleHeart,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        _showHeart
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: _showHeart ? scheme.tertiary : scheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _showHeart
                              ? 'Double-tap Byte to hide the heart'
                              : 'Double-tap Byte to leave a heart',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    hint: 'Plays Byte\'s sound',
                    child: FilledButton.icon(
                      onPressed: _isPlaying ? null : _playBeep,
                      style: _isPlaying
                          ? FilledButton.styleFrom(
                              disabledBackgroundColor: scheme.secondary,
                              disabledForegroundColor: scheme.onSecondary,
                            )
                          : null,
                      icon: _isPlaying
                          ? _PlayingIcon(reduceMotion: reduceMotion)
                          : const Icon(Icons.volume_up_rounded),
                      label: Text(_isPlaying ? 'Playing...' : 'Play beep'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A short beep from Byte. The button rests while it plays.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  if (_errorMessage != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.error,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: scheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.graphic_eq_rounded,
                                color: scheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    beepCountLabel(_beepCount),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Each play adds one beep.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: canReset ? _confirmReset : null,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Reset count'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BytePortrait extends StatelessWidget {
  const _BytePortrait({
    required this.side,
    required this.showHeart,
    required this.onDoubleTap,
  });

  final double side;
  final bool showHeart;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Duration duration = motionDuration(
      context,
      const Duration(milliseconds: 180),
    );
    final double heartSize = math.max(28, side * 0.16);

    return Semantics(
      button: true,
      label: _byteLabel,
      hint: showHeart
          ? 'Heart is showing. Double tap to hide it.'
          : 'Double tap to show a heart.',
      child: GestureDetector(
        key: PetScreen.portraitKey,
        behavior: HitTestBehavior.opaque,
        onDoubleTap: onDoubleTap,
        child: SizedBox(
          width: side,
          height: side,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  _byteAsset,
                  width: side,
                  height: side,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  isAntiAlias: false,
                  semanticLabel: _byteLabel,
                  errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) {
                    return const _MissingArtwork(asset: _byteAsset);
                  },
                ),
              ),
              Positioned(
                top: side * 0.06,
                right: side * 0.08,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    excluding: !showHeart,
                    child: AnimatedOpacity(
                      key: PetScreen.heartKey,
                      opacity: showHeart ? 1 : 0,
                      duration: duration,
                      curve: Curves.easeOut,
                      child: AnimatedScale(
                        scale: showHeart ? 1 : 0.6,
                        duration: duration,
                        curve: Curves.easeOut,
                        child: Icon(
                          Icons.favorite_rounded,
                          size: heartSize,
                          color: scheme.tertiary,
                          semanticLabel: 'Heart',
                        ),
                      ),
                    ),
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

class _MissingArtwork extends StatelessWidget {
  const _MissingArtwork({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Text(
        'Add $asset',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PlayingIcon extends StatelessWidget {
  const _PlayingIcon({required this.reduceMotion});

  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSecondary;
    if (reduceMotion) {
      return Icon(Icons.graphic_eq_rounded, color: color);
    }
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2.4, color: color),
    );
  }
}
