import 'dart:math' as math;

import 'package:flutter/material.dart';

class CenteredScroll extends StatelessWidget {
  const CenteredScroll({
    super.key,
    required this.child,
    this.maxWidth = 920,
    this.fillHeight = false,
  });

  final Widget child;
  final double maxWidth;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    const pad = 20.0;

    return LayoutBuilder(
      builder: (context, viewport) {
        final minHeight = math.max(0.0, viewport.maxHeight - pad * 2);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(pad),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Align(
              alignment: fillHeight ? Alignment.topCenter : Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  minHeight: fillHeight ? minHeight : 0,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
