import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bar.dart';
import '../models/bar_review.dart';
import '../providers/bar_review_provider.dart';

class BarReviewSection extends ConsumerStatefulWidget {
  final Bar bar;

  const BarReviewSection({super.key, required this.bar});

  @override
  ConsumerState<BarReviewSection> createState() => _BarReviewSectionState();
}

class _BarReviewSectionState extends ConsumerState<BarReviewSection> {
  late TextEditingController beerController;
  late TextEditingController specialsController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();

    final review =
        ref.read(barReviewProvider)[widget.bar.id] ??
        BarReview(barId: widget.bar.id);

    beerController = TextEditingController(text: review.beerPrices);

    specialsController = TextEditingController(text: review.specials);

    notesController = TextEditingController(text: review.notes);
  }

  @override
  void dispose() {
    beerController.dispose();
    specialsController.dispose();
    notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = ref.watch(barReviewProvider);

    final review = reviews[widget.bar.id] ?? BarReview(barId: widget.bar.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bewertung',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        _RatingRow(
          title: 'Lage',
          value: review.location,
          onChanged: (value) {
            _update('location', value);
          },
        ),

        _RatingRow(
          title: 'Atmosphäre',
          value: review.atmosphere,
          onChanged: (value) {
            _update('atmosphere', value);
          },
        ),

        _RatingRow(
          title: 'Preis',
          value: review.price,
          onChanged: (value) {
            _update('price', value);
          },
        ),

        _RatingRow(
          title: 'Getränke',
          value: review.drinks,
          onChanged: (value) {
            _update('drinks', value);
          },
        ),

        _RatingRow(
          title: 'Service',
          value: review.service,
          onChanged: (value) {
            _update('service', value);
          },
        ),

        const SizedBox(height: 24),

        const Text(
          'Notizen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        _TextFieldSection(
          title: '🍺 Bierpreise',
          controller: beerController,
          onChanged: (value) {
            _updateTexts(beerPrices: value);
          },
        ),

        _TextFieldSection(
          title: '🎉 Specials',
          controller: specialsController,
          onChanged: (value) {
            _updateTexts(specials: value);
          },
        ),

        _TextFieldSection(
          title: '💬 Eigene Notizen',
          controller: notesController,
          maxLines: 4,
          onChanged: (value) {
            _updateTexts(notes: value);
          },
        ),
      ],
    );
  }

  void _update(String category, double value) {
    ref
        .read(barReviewProvider.notifier)
        .updateCategory(barId: widget.bar.id, category: category, value: value);
  }

  void _updateTexts({String? beerPrices, String? specials, String? notes}) {
    ref
        .read(barReviewProvider.notifier)
        .updateTexts(
          barId: widget.bar.id,
          beerPrices: beerPrices,
          specials: specials,
          notes: notes,
        );
  }
}

class _TextFieldSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function(String) onChanged;
  final int maxLines;

  const _TextFieldSection({
    required this.title,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title),

          const SizedBox(height: 6),

          TextField(
            controller: controller,
            maxLines: maxLines,
            onChanged: onChanged,

            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String title;
  final double value;
  final Function(double) onChanged;

  const _RatingRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          SizedBox(width: 110, child: Text(title)),

          Row(
            children: List.generate(5, (index) {
              final star = index + 1.0;

              IconData icon;

              if (value >= star) {
                icon = Icons.star;
              } else if (value >= star - 0.5) {
                icon = Icons.star_half;
              } else {
                icon = Icons.star_border;
              }

              return GestureDetector(
                onTap: () {
                  double newValue;

                  if (value == star) {
                    newValue = star - 0.5;
                  } else {
                    newValue = star;
                  }

                  if (newValue < 0.5) {
                    newValue = 0;
                  }

                  onChanged(newValue);
                },

                child: Icon(icon, size: 26, color: Colors.amber),
              );
            }),
          ),
        ],
      ),
    );
  }
}
