import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starValue = index + 1;

        IconData icon;

        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return IconButton(
          icon: Icon(icon, color: Colors.amber),
          onPressed: () {
            // einfache 0.5 Steps Logik
            final newRating = rating == starValue.toDouble()
                ? starValue - 0.5
                : starValue.toDouble();

            onRatingChanged(newRating.clamp(0.0, 5.0));
          },
        );
      }),
    );
  }
}
