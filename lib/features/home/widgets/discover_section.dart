import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../discover/widgets/random_bar_section.dart';

class DiscoverSection extends StatelessWidget {
  final List<Bar> bars;

  const DiscoverSection({super.key, required this.bars});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Divider(height: 16),

        Text('Entdecken 🍻', style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 8),

        Expanded(child: RandomBarSection(bars: bars)),
      ],
    );
  }
}
