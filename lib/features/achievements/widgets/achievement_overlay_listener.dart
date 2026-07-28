import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/achievement_listener_provider.dart';
import '../providers/achievement_provider.dart';
import 'achievement_unlock_dialog.dart';

class AchievementOverlayListener extends ConsumerStatefulWidget {
  final Widget child;

  const AchievementOverlayListener({super.key, required this.child});

  @override
  ConsumerState<AchievementOverlayListener> createState() =>
      _AchievementOverlayListenerState();
}

class _AchievementOverlayListenerState
    extends ConsumerState<AchievementOverlayListener> {
  bool _checking = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAchievements();
    });
  }

  Future<void> _checkAchievements() async {
    if (_checking) return;

    _checking = true;

    final listener = ref.read(achievementListenerProvider);

    final newAchievements = await listener.checkForNewAchievements();

    for (final achievement in newAchievements) {
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AchievementUnlockDialog(achievement: achievement);
        },
      );

      await listener.markAsSeen(achievement);
    }

    _checking = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(achievementProvider, (previous, next) {
      _checkAchievements();
    });

    return widget.child;
  }
}
