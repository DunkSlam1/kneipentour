class KneipenDayHelper {
  /// Bis zu dieser Uhrzeit zählt der Besuch noch zum vorherigen Kneipentag.
  static const int rolloverHour = 5;

  /// Liefert den aktuellen Kneipentag.
  static DateTime now() {
    return normalize(DateTime.now());
  }

  /// Normalisiert ein Datum auf den Kneipentag.
  static DateTime normalize(DateTime date) {
    if (date.hour < rolloverHour) {
      return date.subtract(const Duration(days: 1));
    }

    return date;
  }

  /// Deutscher Wochentag des aktuellen Kneipentages.
  static String currentWeekday() {
    return weekdayName(now());
  }

  /// Deutscher Wochentag für ein beliebiges Datum.
  static String weekdayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "Montag";
      case DateTime.tuesday:
        return "Dienstag";
      case DateTime.wednesday:
        return "Mittwoch";
      case DateTime.thursday:
        return "Donnerstag";
      case DateTime.friday:
        return "Freitag";
      case DateTime.saturday:
        return "Samstag";
      case DateTime.sunday:
        return "Sonntag";
      default:
        return "";
    }
  }
}
