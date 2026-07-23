import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/device_id_storage.dart';

final deviceIdStorageProvider = Provider<DeviceIdStorage>((ref) {
  return DeviceIdStorage();
});
