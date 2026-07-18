import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kneipentour/features/settings/repository/settings_repository.dart';

import '../model/app_settings.dart';
import 'settings_repository_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final repository = ref.read(settingsRepositoryProvider);

    _loadSettings(repository);

    return const AppSettings();
  }

  Future<void> _loadSettings(SettingsRepository repository) async {
    final settings = await repository.loadSettings();

    state = settings;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(settingsRepositoryProvider);

    await repository.saveThemeMode(mode);

    state = state.copyWith(themeMode: mode);
  }
}
