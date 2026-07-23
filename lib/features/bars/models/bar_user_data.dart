class BarUserData {
  final String barId;

  final bool visited;
  final bool favorite;

  final double rating;

  final DateTime? visitedAt;

  const BarUserData({
    required this.barId,
    this.visited = false,
    this.favorite = false,
    this.rating = 0.0,
    this.visitedAt,
  });

  BarUserData copyWith({
    bool? visited,
    bool? favorite,
    double? rating,
    DateTime? visitedAt,
  }) {
    return BarUserData(
      barId: barId,
      visited: visited ?? this.visited,
      favorite: favorite ?? this.favorite,
      rating: rating ?? this.rating,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barId': barId,
      'visited': visited,
      'favorite': favorite,
      'rating': rating,
      'visitedAt': visitedAt?.toIso8601String(),
    };
  }

  factory BarUserData.fromJson(Map<String, dynamic> json) {
    return BarUserData(
      barId: json['barId'],
      visited: json['visited'] ?? false,
      favorite: json['favorite'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      visitedAt: json['visitedAt'] != null
          ? DateTime.parse(json['visitedAt'])
          : null,
    );
  }
}
