class BarReviewData {
  final String barId;

  final double location;
  final double atmosphere;
  final double price;
  final double drinks;
  final double service;

  final String beerPrices;
  final String specials;
  final String notes;

  const BarReviewData({
    required this.barId,
    this.location = 0.0,
    this.atmosphere = 0.0,
    this.price = 0.0,
    this.drinks = 0.0,
    this.service = 0.0,
    this.beerPrices = '',
    this.specials = '',
    this.notes = '',
  });

  factory BarReviewData.fromJson(String barId, Map<String, dynamic> json) {
    return BarReviewData(
      barId: barId,

      location: (json['location'] ?? 0).toDouble(),
      atmosphere: (json['atmosphere'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      drinks: (json['drinks'] ?? 0).toDouble(),
      service: (json['service'] ?? 0).toDouble(),

      beerPrices: json['beerPrices'] ?? '',
      specials: json['specials'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  BarReviewData copyWith({
    double? location,
    double? atmosphere,
    double? price,
    double? drinks,
    double? service,
    String? beerPrices,
    String? specials,
    String? notes,
  }) {
    return BarReviewData(
      barId: barId,

      location: location ?? this.location,
      atmosphere: atmosphere ?? this.atmosphere,
      price: price ?? this.price,
      drinks: drinks ?? this.drinks,
      service: service ?? this.service,

      beerPrices: beerPrices ?? this.beerPrices,
      specials: specials ?? this.specials,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'atmosphere': atmosphere,
      'price': price,
      'drinks': drinks,
      'service': service,

      'beerPrices': beerPrices,
      'specials': specials,
      'notes': notes,
    };
  }
}
