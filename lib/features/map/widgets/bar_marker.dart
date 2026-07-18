import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';

class BarMarker extends StatelessWidget {
  final Bar bar;
  final bool isSelected;
  final VoidCallback onTap;

  const BarMarker({
    super.key,
    required this.bar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color markerColor;

    if (isSelected) {
      markerColor = Colors.blue;
    } else if (bar.visited) {
      markerColor = Colors.green;
    } else {
      markerColor = Colors.red;
    }

    final size = isSelected ? 44.0 : 36.0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Goldener Rand für Favoriten
          if (bar.favorite)
            Icon(Icons.location_on, color: Colors.amber, size: size + 2),

          // Eigentlicher Marker
          Icon(Icons.location_on, color: markerColor, size: size),
        ],
      ),
    );
  }
}
