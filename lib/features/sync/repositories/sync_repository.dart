import '../models/sync_config.dart';
import '../storage/sync_storage.dart';

import '../storage/device_id_storage.dart';
import 'package:uuid/uuid.dart';

class SyncRepository {
  final SyncStorage _storage;
  final DeviceIdStorage _deviceStorage;

  SyncRepository(this._storage, this._deviceStorage);

  Future<SyncConfig> loadConfig() async {
    final tourId = await _storage.loadTourId();
    final deviceId = await loadDeviceId();

    return SyncConfig(tourId: tourId, deviceId: deviceId, loaded: true);
  }

  Future<String> loadDeviceId() async {
    final existing = await _deviceStorage.loadDeviceId();

    if (existing != null) {
      return existing;
    }

    final id = const Uuid().v4();

    await _deviceStorage.saveDeviceId(id);

    return id;
  }

  Future<void> saveTourId(String tourId) async {
    await _storage.saveTourId(tourId);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
