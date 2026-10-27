import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface,
                Color.lerp(scheme.surface, scheme.primaryContainer, 0.55)!,
                Color.lerp(scheme.surface, scheme.secondaryContainer, 0.45)!,
              ],
            ),
          ),
        ),
        _Glow(color: scheme.primary, size: 320, top: -100, left: -110),
        _Glow(color: scheme.tertiary, size: 360, bottom: -130, right: -130),
        _Glow(color: scheme.secondary, size: 240, top: 240, right: -80),
        _Glow(color: scheme.primary, size: 220, bottom: 110, left: -90),
        _Outline(color: scheme.primary, size: 260, top: 70, left: -70),
        _Outline(color: scheme.primary, size: 150, top: 150, right: 60),
        _Outline(color: scheme.tertiary, size: 320, bottom: -90, left: 140),
        _Outline(
          color: scheme.primary,
          size: 110,
          bottom: 190,
          right: 40,
          square: true,
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Color color;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.32),
          ),
        ),
      ),
    );
  }
}

class _Outline extends StatelessWidget {
  const _Outline({
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.square = false,
  });

  final Color color;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final shape = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: square ? BorderRadius.circular(size * 0.28) : null,
        border: Border.all(color: color.withValues(alpha: 0.16), width: 1.5),
      ),
    );

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: square ? Transform.rotate(angle: math.pi / 8, child: shape) : shape,
    );
  }
}
