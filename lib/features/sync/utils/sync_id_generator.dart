import 'dart:math';

class SyncIdGenerator {
  static String generate() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random();

    final code = List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return code;
  }
}
