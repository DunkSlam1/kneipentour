import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/sync_data_repository.dart';

final syncDataRepositoryProvider = Provider<SyncDataRepository>((ref) {
  return SyncDataRepository();
});
