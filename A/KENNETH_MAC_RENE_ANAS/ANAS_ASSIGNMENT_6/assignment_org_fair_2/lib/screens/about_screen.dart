import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About the fair')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 2.2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary,
                          colors.primary.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: Icon(
                      Icons.celebration_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    bottom: 20,
                    child: Text(
                      'CICT Org Fair 2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _AboutDetail(
            icon: Icons.calendar_month_outlined,
            title: 'November 5, 2026',
            subtitle: '8:00 AM to 3:00 PM',
          ),
          const SizedBox(height: 20),
          const _AboutDetail(
            icon: Icons.location_on_outlined,
            title: 'CICT Building lobby',
            subtitle: 'West Visayas State University, La Paz, Iloilo City',
          ),
          const SizedBox(height: 20),
          const _AboutDetail(
            icon: Icons.info_outline,
            title:
                'Visit the booths, meet the officers, and join an org right '
                'from this app.',
          ),
        ],
      ),
    );
  }
}

class _AboutDetail extends StatelessWidget {
  const _AboutDetail({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
