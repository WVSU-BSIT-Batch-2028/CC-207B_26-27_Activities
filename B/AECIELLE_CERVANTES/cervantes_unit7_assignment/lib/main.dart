import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'data/cms/contentful_source.dart';
import 'data/event_repository.dart';
import 'data/orgs.dart';
import 'screens/about_screen.dart';
import 'screens/home_shell.dart';

void main() {
  final eventSource = ContentfulEventSource(
    http.Client(),
    spaceId: 'yuf4ngrc1z39',
    token: '0jyD6Aa2AtU18EJIJ-Wqaey8jz1twkgQ95AsgjMuSyw',
  );
  final eventRepository = EventRepository(eventSource);

  runApp(
    OrgFairApp(
      repository: OrgRepository(),
      eventRepository: eventRepository,
    ),
  );
}

class OrgFairApp extends StatelessWidget {
  const OrgFairApp({
    super.key,
    required this.repository,
    required this.eventRepository,
  });

  final OrgRepository repository;
  final EventRepository eventRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CICT Org Fair',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: HomeShell(
        repository: repository,
        eventRepository: eventRepository,
      ),
      routes: {AboutScreen.routeName: (_) => const AboutScreen()},
    );
  }
}