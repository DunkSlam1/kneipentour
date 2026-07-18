import 'package:flutter/material.dart';
import '../models/bar.dart';

IconData getBarIcon(BarType type) {
  switch (type) {
    case BarType.pub:
      return Icons.sports_bar;

    case BarType.bar:
      return Icons.local_bar;

    case BarType.sportsbar:
      return Icons.sports_soccer;

    case BarType.winebar:
      return Icons.wine_bar;
  }
}
