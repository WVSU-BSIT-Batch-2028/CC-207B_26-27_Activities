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

  final OrgRepository repository;

  final EventRepository events;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CICT Org Fair',
      theme: ThemeData(colorSchemeSeed: Colors.lightBlue),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      home: HomeShell(repository: repository, events: events),
      routes: {AboutScreen.routeName: (_) => const AboutScreen()},
    );
  }
}
