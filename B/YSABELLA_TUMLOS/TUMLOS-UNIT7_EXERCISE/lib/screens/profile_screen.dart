import 'package:flutter/material.dart';

import '../models/class_slot.dart';
import '../models/profile_info.dart';
import '../widgets/centered_scroll.dart';
import '../widgets/glass_bar_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_chip.dart';
import '../widgets/glass_fill.dart';
import '../widgets/glass_icon.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/glass_title.dart';
import '../widgets/info_tile.dart';
import '../widgets/section_heading.dart';

const String profileName = 'Ysabella Nicole D. Tumlos';
const String profileTagline = 'Consistency creates queens';
const String profilePhoto = 'assets/images/ysai.jpg';

const List<String> profileBio = [
  'Commonly known as Ysai\u2014so much so that my actual name has practically '
      'become a trivia question. Born and raised in Iloilo City, I\u2019m '
      'Spanish-Filipino and spent 14 years in Ateneo\u2019s blue-blooded halls '
      'before trading one shade of blue for another at WVSU.',
  'As the youngest in the class, I proudly embrace my role as the resident '
      'baby. My ambitions are refreshingly simple: pass this course, enjoy the '
      'ride, and eventually get rich enough to make working optional. After '
      'all, why choose between academic survival and the finer things in life '
      'when I can aspire to both?',
];

const List<ProfileInfo> profileInfos = [
  ProfileInfo(
    icon: Icons.cake_rounded,
    label: 'Birthdate',
    value: '11/03/2006',
  ),
  ProfileInfo(
    icon: Icons.home_rounded,
    label: 'Address',
    value: 'Iloilo City, Iloilo, Philippines',
  ),
  ProfileInfo(
    icon: Icons.email_rounded,
    label: 'Email',
    value: 'ysabellanicolede.tumlos@wvsu.edu.ph',
  ),
  ProfileInfo(
    icon: Icons.school_rounded,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.menu_book_rounded,
    label: 'Course',
    value: 'BS Information Technology / 3B CBS',
  ),
];

const List<(IconData, String)> profileInterests = [
  (Icons.music_note_rounded, 'Music'),
  (Icons.local_florist_rounded, 'Flowers'),
  (Icons.checkroom_rounded, 'Fashion'),
  (Icons.local_cafe_rounded, 'Cafe-hopping'),
  (Icons.restaurant_rounded, 'Eating'),
];

const List<String> profileHobbies = [
  'Singing',
  'Binge-watching',
  'Running',
  'Eating',
  'Decorating',
];

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Mon',
    time: '9:00 AM\u201312:00 PM',
    subject: 'CIT 251: Security Compliance and Governance',
  ),
  ClassSlot(
    day: 'Tue',
    time: '7:00\u20139:00 AM',
    subject: 'CIT 210: Web Systems and Technology',
  ),
  ClassSlot(
    day: 'Wed',
    time: '4:00\u20136:00 PM',
    subject: 'CC 207B: Application Development',
  ),
  ClassSlot(
    day: 'Thu',
    time: '1:00\u20132:30 PM',
    subject: 'CC 208: Methods of Research in Computing',
  ),
  ClassSlot(day: 'Fri', time: '\u2014', subject: 'No school, yay!'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget infoCard = Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              'Personal Information',
              icon: Icons.badge_rounded,
            ),
            const SizedBox(height: 6),
            for (final info in profileInfos) InfoTile(info: info),
          ],
        ),
      ),
    );

    final Widget bioCard = Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const GlassIcon(
                  icon: Icons.auto_stories_rounded,
                  size: 40,
                  iconSize: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'My Biography',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            for (final (i, paragraph) in profileBio.indexed) ...[
              if (i > 0) const SizedBox(height: 14),
              Text(
                paragraph,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );

    final Widget interestsCard = Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading('Interests', icon: Icons.auto_awesome_rounded),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final (icon, label) in profileInterests)
                  GlassChip(icon: icon, label: label),
              ],
            ),
          ],
        ),
      ),
    );

    final scheme = theme.colorScheme;

    final Widget hobbiesCard = Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading('My Hobbies', icon: Icons.interests_rounded),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final hobby in profileHobbies) Chip(label: Text(hobby)),
              ],
            ),
          ],
        ),
      ),
    );

    final Widget scheduleCard = Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              'My Class Schedule',
              icon: Icons.calendar_month_rounded,
            ),
            const SizedBox(height: 14),
            Table(
              border: TableBorder.all(color: scheme.outlineVariant),
              columnWidths: const {
                0: FixedColumnWidth(42),
                1: FixedColumnWidth(82),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: scheme.primaryContainer),
                  children: [
                    for (final title in ['Day', 'Time', 'Subject'])
                      _cell(title, bold: true),
                  ],
                ),
                for (final slot in classSchedule)
                  TableRow(
                    children: [
                      _cell(slot.day),
                      _cell(slot.time),
                      _cell(slot.subject),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GlassTitle(profileName),
        flexibleSpace: const GlassBarBackground(),
      ),
      body: CenteredScroll(
        maxWidth: 1000,
        fillHeight: true,
        child: GlassCard(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 640;

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(isWide: isWide),
                  const SizedBox(height: 20),
                  if (isWide) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              infoCard,
                              const SizedBox(height: 20),
                              scheduleCard,
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              bioCard,
                              const SizedBox(height: 20),
                              interestsCard,
                              const SizedBox(height: 20),
                              hobbiesCard,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    infoCard,
                    const SizedBox(height: 20),
                    bioCard,
                    const SizedBox(height: 20),
                    interestsCard,
                    const SizedBox(height: 20),
                    hobbiesCard,
                    const SizedBox(height: 20),
                    scheduleCard,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _cell(String text, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.isWide});

  final bool isWide;

  static const double _bannerHeight = 96;
  static const double _photoSize = 96;
  static const double _photoOuter = _photoSize + 14;
  static const double _photoTop = _bannerHeight - _photoOuter / 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Widget links = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassIconButton(
          icon: Icons.mail_outline_rounded,
          tooltip: 'Email',
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        GlassIconButton(
          icon: Icons.code_rounded,
          tooltip: 'GitHub',
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        GlassIconButton(
          icon: Icons.link_rounded,
          tooltip: 'Website',
          onPressed: () {},
        ),
      ],
    );

    final Widget photo = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.tertiary],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surface,
        ),
        child: ClipOval(
          child: Image.asset(
            profilePhoto,
            width: _photoSize,
            height: _photoSize,
            fit: BoxFit.cover,
            semanticLabel: 'Photo of $profileName',
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _bannerHeight,
              child: _Banner(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: _photoTop, left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  photo,
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: _bannerHeight - _photoTop + 12),
                        Text(
                          profileName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profileTagline,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        if (isWide) ...[
                          const SizedBox(height: 14),
                          links,
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isWide) ...[
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.only(left: 20), child: links),
        ],
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.30),
                  scheme.tertiary.withValues(alpha: 0.22),
                ],
              ),
            ),
          ),
          const Positioned(right: -24, top: -34, child: _Bubble(size: 120)),
          const Positioned(right: 110, bottom: -44, child: _Bubble(size: 86)),
          const Positioned(left: 150, top: -30, child: _Bubble(size: 60)),
          Positioned(
            right: 30,
            top: 24,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 30,
              color: scheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.onSurface.withValues(alpha: 0.18),
            scheme.onSurface.withValues(alpha: 0.03),
          ],
        ),
        border: Border.all(
          color: scheme.onSurface.withValues(alpha: 0.22),
          width: 1.2,
        ),
      ),
    );
  }
}
