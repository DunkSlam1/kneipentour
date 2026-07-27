import 'package:flutter/material.dart';

import '../../achievements/pages/achievements_page.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AchievementsPage()),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            children: [
              Icon(Icons.emoji_events, size: 32, color: Colors.amber.shade700),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      'Erfolge',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Deine Sammlung entdecken',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
