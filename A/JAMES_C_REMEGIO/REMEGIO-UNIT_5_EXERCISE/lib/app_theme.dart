import 'package:flutter/material.dart';

/// Cobalt seed for the Material 3 theme.
///
/// [buildAppTheme] starts from this seed, then tunes the scheme toward a deep
/// navy foundation, electric cyan highlights, silver surfaces, and a small
/// warm accent.
const Color appSeedColor = Color(0xFF0A2F6B);

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: appSeedColor,
    brightness: Brightness.light,
  );

  final ColorScheme scheme = base.colorScheme.copyWith(
    primary: const Color(0xFF0C2E5C),
    onPrimary: const Color(0xFFF5F9FF),
    primaryContainer: const Color(0xFF1B4F93),
    onPrimaryContainer: const Color(0xFFD6E6FF),
    secondary: const Color(0xFF00B4D0),
    onSecondary: const Color(0xFF032028),
    secondaryContainer: const Color(0xFFCBF6FF),
    onSecondaryContainer: const Color(0xFF003844),
    tertiary: const Color(0xFFB07D38),
    onTertiary: const Color(0xFF2B1C06),
    tertiaryContainer: const Color(0xFFFFE6C4),
    onTertiaryContainer: const Color(0xFF3E2808),
    background: const Color(0xFFF3F6FA),
    onBackground: const Color(0xFF132033),
    surface: const Color(0xFFFBFCFE),
    onSurface: const Color(0xFF132033),
    surfaceVariant: const Color(0xFFE4EAF2),
    onSurfaceVariant: const Color(0xFF3E4C5F),
    outline: const Color(0xFFC5D0DE),
    outlineVariant: const Color(0xFFD5DEE9),
  );

  final TextTheme textTheme = base.textTheme.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );
  final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: scheme.outlineVariant),
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.background,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: cardShape,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.background,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.secondaryContainer,
      height: 72,
      labelTextStyle: MaterialStateProperty.resolveWith((
        Set<MaterialState> states,
      ) {
        final bool selected = states.contains(MaterialState.selected);
        return textTheme.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        final bool selected = states.contains(MaterialState.selected);
        return IconThemeData(
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.surfaceVariant,
        disabledForegroundColor: scheme.onSurface.withOpacity(0.38),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.pressed)) {
            return scheme.secondary.withOpacity(0.28);
          }
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.focused)) {
            return scheme.secondary.withOpacity(0.14);
          }
          return null;
        }),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
    ),
  );
}
