
import 'package:flutter/material.dart';

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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(info.icon),
          const SizedBox(width: 12),
          Text('${info.label}: '),
          Expanded(
            child: Text(info.value),
          ),
        ],
      ),
    );
  }
}
