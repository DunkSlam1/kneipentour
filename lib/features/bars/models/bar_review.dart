class BarReview {
  final String barId;

  // ⭐ Kategorien
  final double location;
  final double atmosphere;
  final double price;
  final double drinks;
  final double service;

  // 📝 Freitext
  final String beerPrices;
  final String specials;
  final String notes;

  const BarReview({
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

  BarReview copyWith({
    double? location,
    double? atmosphere,
    double? price,
    double? drinks,
    double? service,

    String? beerPrices,
    String? specials,
    String? notes,
  }) {
    return BarReview(
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
}
