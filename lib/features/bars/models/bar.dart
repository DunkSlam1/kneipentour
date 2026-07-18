enum BarType {
  pub, // 🍺 klassische Kneipe
  bar, // 🍸 Cocktailbar
  sportsbar, // ⚽ Sportsbar
  winebar, // 🍷 Weinbar
}

/// Öffnungszeiten Modell
class OpeningHours {
  final Map<String, List<String>> weekly;

  const OpeningHours({required this.weekly});
}

class Bar {
  final String id;
  final String name;
  final String address;
  final String district;

  final double latitude;
  final double longitude;

  final BarType type;

  final OpeningHours? openingHours; // ⭐ NEU

  bool visited;
  bool favorite;

  double rating; // ⭐ NEU (kein nullable nötig)

  DateTime? visitedAt;

  Bar({
    required this.id,
    required this.name,
    required this.address,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.openingHours, // ⭐ NEU
    this.visited = false,
    this.favorite = false,
    this.rating = 0.0,
    this.visitedAt,
  });

  Bar copyWith({
    bool? visited,
    bool? favorite,
    double? rating,
    DateTime? visitedAt,
    BarType? type,
    OpeningHours? openingHours, // ⭐ NEU
  }) {
    return Bar(
      id: id,
      name: name,
      address: address,
      district: district,
      latitude: latitude,
      longitude: longitude,
      type: type ?? this.type,
      openingHours: openingHours ?? this.openingHours, // ⭐ NEU
      visited: visited ?? this.visited,
      favorite: favorite ?? this.favorite,
      rating: rating ?? this.rating,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }
}
