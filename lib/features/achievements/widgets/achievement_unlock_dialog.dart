import 'package:flutter/material.dart';

import '../models/achievement.dart';
import 'achievement_badge.dart';
import 'confetti_overlay.dart';

class AchievementUnlockDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockDialog({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Text('🏆', style: TextStyle(fontSize: 42)),

                const SizedBox(height: 12),

                Text(
                  'Neuer Erfolg!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                AchievementBadge(icon: achievement.icon, unlocked: true),

                const SizedBox(height: 20),

                Text(
                  achievement.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  achievement.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Weiter'),
                ),
              ],
            ),
          ),

          const Positioned.fill(child: IgnorePointer(child: ConfettiOverlay())),
        ],
      ),
    );
  }
}
