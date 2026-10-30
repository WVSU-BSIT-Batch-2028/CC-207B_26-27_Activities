import 'package:flutter/material.dart';

import 'home_shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE85D93),
          surface: const Color(0xFFFFF8FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8FA),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shadowColor: const Color(0xFFE85D93).withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFCE0EA),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            );
          }),
        ),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}
