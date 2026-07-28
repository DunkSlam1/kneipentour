import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kneipentour/app/main_navigation.dart';
import 'package:kneipentour/features/settings/providers/settings_provider.dart';
import 'package:kneipentour/features/sync/providers/sync_startup_provider.dart';
import 'package:kneipentour/features/achievements/widgets/achievement_overlay_listener.dart';

class KneipenTourApp extends ConsumerWidget {
  const KneipenTourApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ref.watch(syncStartupProvider);

    return MaterialApp(
      title: 'KneipenTour',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),

      darkTheme: ThemeData(
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      themeMode: settings.themeMode,

      builder: (context, child) {
        return AchievementOverlayListener(child: child!);
      },

      home: const AchievementOverlayListener(child: MainNavigation()),
    );
  }
}
