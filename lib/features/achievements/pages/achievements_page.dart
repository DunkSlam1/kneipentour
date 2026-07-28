import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/achievement_provider.dart';
import '../models/achievement.dart';
import '../widgets/achievement_badge.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  Map<AchievementCategory, List<dynamic>> _groupByCategory(
    List<dynamic> achievements,
  ) {
    final grouped = <AchievementCategory, List<dynamic>>{};

    for (final achievement in achievements) {
      grouped.putIfAbsent(achievement.category, () => []);

      grouped[achievement.category]!.add(achievement);
    }

    return grouped;
  }

  List<Widget> _buildCategorySections(
    Map<AchievementCategory, List<dynamic>> groups, {
    bool lockedStyle = false,
  }) {
    return groups.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          Text(
            _categoryName(entry.key),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 8),

          ...entry.value.map(
            (achievement) => lockedStyle
                ? Opacity(
                    opacity: 0.55,
                    child: _AchievementTile(achievement: achievement),
                  )
                : _AchievementTile(achievement: achievement),
          ),

          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  String _categoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.progress:
        return '🏆 Fortschritt';

      case AchievementCategory.explorer:
        return '🍻 Entdecker';

      case AchievementCategory.collector:
        return '⭐ Sammler';

      case AchievementCategory.discovery:
        return '🎲 Discovery';

      case AchievementCategory.special:
        return '🏅 Besondere Leistungen';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementProvider);

    final unlocked = achievements.where((a) => a.isUnlocked).toList();

    final locked = achievements.where((a) => !a.isUnlocked).toList();

    final unlockedGroups = _groupByCategory(unlocked);
    final lockedGroups = _groupByCategory(locked);

    final progress = achievements.isEmpty
        ? 0.0
        : unlocked.length / achievements.length;

    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Erfolge')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Du hast ${unlocked.length} von ${achievements.length} Erfolgen freigeschaltet.',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()} %',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            '✨ Freigeschaltet (${unlocked.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          if (unlocked.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Noch keine Erfolge freigeschaltet.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          ..._buildCategorySections(unlockedGroups),

          const SizedBox(height: 32),

          Text(
            '🔒 Noch offen (${locked.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ..._buildCategorySections(lockedGroups, lockedStyle: true),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final dynamic achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AchievementBadge(
              icon: achievement.icon,
              unlocked: achievement.isUnlocked,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(achievement.description),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value: achievement.progress,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${achievement.currentValue} / ${achievement.requiredValue}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              achievement.isUnlocked ? Icons.check_circle : Icons.lock,
              color: achievement.isUnlocked ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
