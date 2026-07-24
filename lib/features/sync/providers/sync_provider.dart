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
    final deviceId = await repository.loadDeviceId();

    final updatedConfig = SyncConfig(
      tourId: config.tourId,
      deviceId: deviceId,
      loaded: true,
    );

    return updatedConfig;
  }

  Future<void> createTour(String tourId) async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.saveTourId(tourId);

    final deviceId = (state.value!).deviceId;

    state = AsyncData(
      SyncConfig(tourId: tourId, deviceId: deviceId, loaded: true),
    );
  }

  Future<void> joinTour(String tourId) async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.saveTourId(tourId);

    final deviceId = (state.value!).deviceId;

    final config = SyncConfig(tourId: tourId, deviceId: deviceId, loaded: true);

    state = AsyncData(config);
  }

  Future<void> clearSync() async {
    final repository = ref.read(syncRepositoryProvider);

    await repository.clear();

    final deviceId = (state.value!).deviceId;

    state = AsyncData(SyncConfig(deviceId: deviceId, loaded: true));
  }
}
