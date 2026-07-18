import 'package:flutter/material.dart';

import '../../bars/models/bar.dart';
import '../../bars/pages/bar_detail_page.dart';
import '../models/discover_card_state.dart';

class RollingBarCard extends StatelessWidget {
  final List<String> names;
  final Bar? selectedBar;
  final DiscoverCardState cardState;

  const RollingBarCard({
    super.key,
    required this.names,
    required this.cardState,
    this.selectedBar,
  });

  @override
  Widget build(BuildContext context) {
    switch (cardState) {
      case DiscoverCardState.idle:
        return _buildIdleCard();

      case DiscoverCardState.rolling:
        return _buildRollingCard();

      case DiscoverCardState.winner:
        return _buildWinnerCard(context);
    }
  }

  Widget _buildIdleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text('...'),
            Divider(),
            Text(
              'Kneipe ziehen 🍻',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text('...'),
          ],
        ),
      ),
    );
  }

  Widget _buildRollingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(names.isNotEmpty ? names[0] : '...'),

            const Divider(),

            Text(
              names.length > 1 ? names[1] : 'Kneipe wird gezogen...',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            Text(names.length > 2 ? names[2] : '...'),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerCard(BuildContext context) {
    if (selectedBar == null) {
      return _buildIdleCard();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_bar),

                const SizedBox(width: 8),

                Text(
                  selectedBar!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BarDetailPage(barId: selectedBar!.id),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
