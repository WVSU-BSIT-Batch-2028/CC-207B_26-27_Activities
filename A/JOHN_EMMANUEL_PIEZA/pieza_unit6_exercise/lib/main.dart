
import 'package:flutter/material.dart';
import 'pet_screen.dart';
import 'gallery_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorSchemeSeed: const Color.fromARGB(255, 38, 90, 40),
    );

    return MaterialApp(
      title: 'Pieza Profile',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Favorite Animal',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}
class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
}

const List<ProfileInfo> infos = [
  ProfileInfo(
    icon: Icons.cake,
    label: 'Birthday',
    value: 'August 19, 2005',
  ),
  ProfileInfo(
    icon: Icons.location_on,
    label: 'Address',
    value: 'Pavia, Iloilo',
  ),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'johnemmanuel.pieza@wvsu.edu.ph',
  ),
  ProfileInfo(
    icon: Icons.mic,
    label: 'Favorite Artist',
    value: 'Travis Scott',
  ),
  ProfileInfo(
    icon: Icons.music_note,
    label: 'Favorite Song',
    value: 'Apple Pie by Travis Scott',
  ),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
];

const List<String> hobbies = [
  'Gaming',
  'Music',
  'UI/UX Design',
  'Basketball',
  'Drawing',
];

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Mon',
    time: '7:00-9:00',
    subject: 'HUMAN COMPUTER INTERACTION 2',
  ),
  ClassSlot(
    day: 'Tue',
    time: '9:00-12:00',
    subject: 'APPLICATION DEVELEPMENT',
  ),
  ClassSlot(
    day: 'Wed',
    time: '1:00-3:00',
    subject: 'WEB SYSTEMS',
  ),
  ClassSlot(
    day: 'Thu',
    time: '9:00-11:00',
    subject: 'TECHNOPRENEURSHIP',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('John Emmanuel Pieza'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of John Emmanuel Pieza',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.account_circle,
                          size: 96,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Emmanuel Pieza',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT 3A',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),


            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    for (final info in infos) ...[
                      InfoTile(info: info),
                      if (!identical(info, infos.last))
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),


            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am an IT student who enjoys computers and learning new '
                      'technologies. I am currently learning Flutter and '
                      'building mobile apps. I am also interested in AI Prompts '
                      'and creating projects that solve real-world problems. '
                      'In my free time, I like gaming and listening to music.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: constraints.maxWidth < 320
                                ? 320
                                : constraints.maxWidth,
                            child: Table(
                              border: TableBorder.all(
                                color: colorScheme.outlineVariant,
                              ),
                              columnWidths: const {
                                0: FixedColumnWidth(55),
                                1: FixedColumnWidth(100),
                                2: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                  ),
                                  children: const [
                                    ScheduleCell(
                                      text: 'Day',
                                      isHeader: true,
                                    ),
                                    ScheduleCell(
                                      text: 'Time',
                                      isHeader: true,
                                    ),
                                    ScheduleCell(
                                      text: 'Subject',
                                      isHeader: true,
                                    ),
                                  ],
                                ),

                                for (final slot in classSchedule)
                                  TableRow(
                                    children: [
                                      ScheduleCell(
                                        text: slot.day,
                                      ),
                                      ScheduleCell(
                                        text: slot.time,
                                      ),
                                      ScheduleCell(
                                        text: slot.subject,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            info.icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 130,
            child: Text(
              info.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const ScheduleCell({
    super.key,
    required this.text,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader
              ? FontWeight.bold
              : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
