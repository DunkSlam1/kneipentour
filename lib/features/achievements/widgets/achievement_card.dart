import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.isUnlocked;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 32)),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: unlocked ? null : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(achievement.description),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(value: achievement.progress),

                  const SizedBox(height: 4),

                  Text(
                    '${achievement.currentValue} / ${achievement.requiredValue}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            Icon(
              unlocked ? Icons.check_circle : Icons.lock,
              color: unlocked ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
