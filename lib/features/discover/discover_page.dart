import 'package:flutter/material.dart';

import 'pages/slot_machine_page.dart';
import 'pages/coin_flip_page.dart';
import 'pages/wheel_page.dart';
import 'pages/tour_generator_page.dart';
import 'widgets/discovery_tool_card.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discovery 🍻')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Entdecke neue Kneipen mit verschiedenen Tools.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 16),

          DiscoveryToolCard(
            title: 'Slot Machine',
            subtitle: 'Lass die Walzen entscheiden.',
            icon: Icons.casino,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SlotMachinePage()),
              );
            },
          ),

          const SizedBox(height: 12),

          DiscoveryToolCard(
            title: 'Münzwurf',
            subtitle: 'Kopf oder Zahl entscheidet zwischen zwei Kneipen.',
            icon: Icons.monetization_on,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CoinFlipPage()),
              );
            },
          ),

          const SizedBox(height: 12),

          DiscoveryToolCard(
            title: 'Glücksrad',
            subtitle: 'Drehe das Rad und entdecke eine Kneipe.',
            icon: Icons.blur_circular,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WheelPage()),
              );
            },
          ),

          const SizedBox(height: 12),

          DiscoveryToolCard(
            title: 'Tourgenerator',
            subtitle: 'Plane deine nächste Kneipentour.',
            icon: Icons.route,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TourGeneratorPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
