import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement(
        icon: Icons.local_bar,
        title: 'Erste Kneipe besucht',
        description: 'Du hast deine erste Kneipe entdeckt.',
        unlocked: true,
      ),
      _Achievement(
        icon: Icons.star,
        title: 'Kneipenkenner',
        description: 'Bewerte deine ersten 5 Kneipen.',
        unlocked: false,
      ),
      _Achievement(
        icon: Icons.map,
        title: 'Stadtentdecker',
        description: 'Besuche Kneipen in mehreren Stadtteilen.',
        unlocked: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Erfolge')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: achievements.length,

        itemBuilder: (context, index) {
          final achievement = achievements[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(achievement.icon)),

              title: Text(achievement.title),

              subtitle: Text(achievement.description),

              trailing: Icon(
                achievement.unlocked ? Icons.check_circle : Icons.lock,
                color: achievement.unlocked ? Colors.green : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Achievement {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;

  const _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });
}
