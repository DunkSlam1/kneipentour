// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../models/bar.dart';
import '../utils/bar_icon_mapper.dart';
import '../utils/opening_status.dart';

class BarCard extends StatelessWidget {
  final Bar bar;
  final VoidCallback onTap;
  final VoidCallback onToggleVisited;
  final VoidCallback onToggleFavorite;
  final ValueChanged<double> onToggleRating;

  const BarCard({
    super.key,
    required this.bar,
    required this.onTap,
    required this.onToggleVisited,
    required this.onToggleFavorite,
    required this.onToggleRating,
  });

  @override
  Widget build(BuildContext context) {
    final openingStatus = OpeningStatusHelper.getStatus(bar.openingHours);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final visitedColor = isDarkMode
        ? const Color(0xFF1B3A1F)
        : const Color(0xFFE8F5E9);

    final visitedTextColor = isDarkMode ? Colors.white : Colors.black87;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: bar.visited ? visitedColor : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 🍻 TYPE ICON
              CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.15),
                child: Icon(
                  getBarIcon(bar.type),
                  color: bar.visited ? Colors.green : Colors.black87,
                ),
              ),

              const SizedBox(width: 12),

              // 📄 TEXTBEREICH
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME + FAVORIT
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bar.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: bar.visited ? visitedTextColor : null,
                            ),
                          ),
                        ),

                        IconButton(
                          icon: Icon(
                            bar.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: onToggleFavorite,
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // ADRESSE
                    Text(
                      bar.address,
                      style: TextStyle(
                        color: bar.visited && isDarkMode
                            ? Colors.white70
                            : Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          openingStatus.state == OpeningState.open
                              ? Icons.circle
                              : Icons.circle,
                          size: 10,
                          color: openingStatus.state == OpeningState.open
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          openingStatus.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: openingStatus.state == OpeningState.open
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    // STATUS
                    Row(
                      children: [
                        Icon(
                          bar.visited
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: bar.visited ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          bar.visited ? 'Besucht' : 'Noch nicht besucht',
                          style: TextStyle(
                            fontSize: 12,
                            color: bar.visited ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ⭐ ACTION BEREICH RECHTS (NEU CLEAN)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // VISITED
                  IconButton(
                    icon: Icon(
                      bar.visited
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: bar.visited ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                    onPressed: onToggleVisited,
                  ),

                  const SizedBox(height: 6),

                  // RATING (⭐⭐⭐⭐⭐)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;

                      IconData icon;

                      if (bar.rating >= starValue) {
                        icon = Icons.star;
                      } else if (bar.rating >= starValue - 0.5) {
                        icon = Icons.star_half;
                      } else {
                        icon = Icons.star_border;
                      }

                      return GestureDetector(
                        onTap: () {
                          double newRating;

                          if (bar.rating == starValue) {
                            newRating = starValue - 0.5;
                          } else {
                            newRating = starValue;
                          }

                          if (newRating < 0.5) {
                            newRating = 0.0; // ⭐ sauberer Reset
                          }

                          onToggleRating(newRating.clamp(0.0, 5.0));
                        },

                        child: Icon(
                          icon,
                          color: Colors.amber,
                          size: 20, // ⭐ leicht größer
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
