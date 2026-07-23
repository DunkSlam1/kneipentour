import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sync_service.dart';
import 'sync_provider.dart';

final syncStartupProvider = FutureProvider<void>((ref) async {
  print('SYNC STARTUP AUSGEFÜHRT');

  final syncConfig = await ref.watch(syncProvider.future);

  print('TOUR: ${syncConfig.tourId}');

  final syncService = SyncService(ref);

  await syncService.syncOnStartup();
});
