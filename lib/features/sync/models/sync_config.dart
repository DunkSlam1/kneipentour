class SyncConfig {
  final String? tourId;
  final String deviceId;
  final bool loaded;

  const SyncConfig({this.tourId, required this.deviceId, this.loaded = false});

  bool get isConnected => tourId != null;
}
