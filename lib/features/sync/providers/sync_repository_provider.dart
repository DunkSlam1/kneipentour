import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/sync_repository.dart';
import '../storage/sync_storage.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(SyncStorage());
});
