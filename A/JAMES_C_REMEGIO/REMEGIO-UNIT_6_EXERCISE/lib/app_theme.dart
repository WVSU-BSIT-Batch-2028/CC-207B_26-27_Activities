import 'package:flutter/material.dart';

/// Cobalt seed for the Material 3 theme.
///
/// [buildAppTheme] starts from this seed, then tunes the scheme toward a deep
/// navy foundation, electric cyan highlights, silver surfaces, and a small
/// warm accent that matches the gold on Byte.
const Color appSeedColor = Color(0xFF0A2F6B);

/// Page color behind the cards. Kept separate from [ColorScheme.surface].
const Color _pageBackground = Color(0xFFF3F6FA);

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
    surface: const Color(0xFFFBFCFE),
    onSurface: const Color(0xFF132033),
    surfaceContainerHighest: const Color(0xFFE4EAF2),
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
  final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: _pageBackground,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _pageBackground,
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
    cardTheme: CardThemeData(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: cardShape,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.secondaryContainer,
      labelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
        height: 1.4,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _pageBackground,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.secondaryContainer,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        final bool selected = states.contains(WidgetState.selected);
        return textTheme.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final bool selected = states.contains(WidgetState.selected);
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
        disabledBackgroundColor: scheme.surfaceContainerHighest,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: buttonShape,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return scheme.secondary.withValues(alpha: 0.28);
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return scheme.secondary.withValues(alpha: 0.14);
          }
          return null;
        }),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        foregroundColor: scheme.primary,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        side: BorderSide(color: scheme.primary),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: buttonShape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
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
