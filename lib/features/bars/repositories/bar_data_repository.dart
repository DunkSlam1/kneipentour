import '../models/bar_user_data.dart';
import '../storage/bar_storage.dart';

class BarDataRepository {
  final BarStorage _storage;

  BarDataRepository(this._storage);

  Future<void> save(Map<String, BarUserData> data) {
    return _storage.save(data);
  }

  Future<Map<String, BarUserData>> load() {
    return _storage.load();
  }

  Future<void> clear() {
    return _storage.clear();
  }
}
