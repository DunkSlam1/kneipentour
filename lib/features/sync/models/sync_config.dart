class SyncConfig {
  final String? tourId;
  final bool loaded;

  const SyncConfig({this.tourId, this.loaded = false});

  bool get isConnected => tourId != null;
}
