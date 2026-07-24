import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sync_service.dart';

final syncStartupProvider = FutureProvider<void>((ref) async {
  final syncService = SyncService(ref);

  await syncService.syncOnStartup();
});
