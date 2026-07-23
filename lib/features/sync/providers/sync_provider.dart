import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_config.dart';
import 'sync_repository_provider.dart';

final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncConfig>(
  SyncNotifier.new,
);

class SyncNotifier extends AsyncNotifier<SyncConfig> {
  @override
  Future<SyncConfig> build() async {
    final repository = ref.read(syncRepositoryProvider);

    final config = await repository.loadConfig();

    print('SYNC CONFIG GELADEN: ${config.tourId}');

    return config;
  }

  Future<void> createTour(String tourId) async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.saveTourId(tourId);

    state = AsyncData(SyncConfig(tourId: tourId));
  }

  Future<void> joinTour(String tourId) async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.saveTourId(tourId);

    final config = SyncConfig(tourId: tourId);

    state = AsyncData(config);
  }

  Future<void> clearSync() async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.clear();

    state = const AsyncData(SyncConfig());
  }
}
