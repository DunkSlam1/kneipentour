import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/settings_repository.dart';
import 'shared_preferences_provider.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return SettingsRepository(prefs);
});
