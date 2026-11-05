import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'data/event_repository.dart';
import 'data/orgs.dart';
import 'screens/about_screen.dart';
import 'screens/home_shell.dart';

void main() => runApp(
  OrgFairApp(
    repository: OrgRepository(),
    events: EventRepository(createEventSource(http.Client())),
  ),
);

class OrgFairApp extends StatelessWidget {
  const OrgFairApp({super.key, required this.repository, required this.events});

  /// Try other modes while you work, for example:
  /// OrgRepository(mode: ServerMode.error)
  final OrgRepository repository;

  /// Where the events come from: your CMS, or the built-in samples.
  /// See config.dart.
  final EventRepository events;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CICT Org Fair',
      theme: fairTheme(Brightness.light),
      darkTheme: fairTheme(Brightness.dark),
      home: HomeShell(repository: repository, events: events),
      // Named routes: screens you can open by name with pushNamed.
      routes: {AboutScreen.routeName: (_) => const AboutScreen()},
    );
  }
}

/// One Material 3 theme for light and dark, so spacing and color stay paired.
ThemeData fairTheme(Brightness brightness) {
  const seed = Color(0xFF0B6E6A);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final base = ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    useMaterial3: true,
  );
  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(64, 48)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}
