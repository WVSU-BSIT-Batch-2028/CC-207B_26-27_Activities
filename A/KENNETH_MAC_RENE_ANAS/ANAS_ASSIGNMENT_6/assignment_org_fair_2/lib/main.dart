import 'package:flutter/material.dart';

import 'data/orgs.dart';
import 'screens/about_screen.dart';
import 'screens/home_shell.dart';

void main() => runApp(OrgFairApp(repository: OrgRepository()));

class OrgFairApp extends StatelessWidget {
  const OrgFairApp({super.key, required this.repository});

  final OrgRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CICT Org Fair',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routes: {'/about': (_) => const AboutScreen()},
      home: HomeShell(repository: repository),
    );
  }
}
