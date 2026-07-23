import '../models/sync_config.dart';
import '../storage/sync_storage.dart';

class SyncRepository {
  final SyncStorage _storage;

  SyncRepository(this._storage);

  Future<SyncConfig> loadConfig() async {
    final tourId = await _storage.loadTourId();

    return SyncConfig(tourId: tourId);
  }

  Future<void> saveTourId(String tourId) async {
    await _storage.saveTourId(tourId);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
