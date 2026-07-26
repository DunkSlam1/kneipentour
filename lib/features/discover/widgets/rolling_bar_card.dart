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

  Widget _buildRollText(String text, {bool highlight = false}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: highlight ? 28 : 18,
        fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRollText('...'),

                  const Divider(),

                  _buildRollText('Kneipe ziehen 🍻', highlight: true),

                  const Divider(),

                  _buildRollText('...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRollingCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRollText(names.isNotEmpty ? names[0] : '...'),

                  const Divider(),

                  _buildRollText(
                    names.length > 1 ? names[1] : 'Kneipe wird gezogen...',
                    highlight: true,
                  ),

                  const Divider(),

                  _buildRollText(names.length > 2 ? names[2] : '...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWinnerCard(BuildContext context) {
    if (selectedBar == null) {
      return _buildIdleCard();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final titleSize = (constraints.maxHeight * 0.14).clamp(14.0, 24.0);

        final iconSize = (constraints.maxHeight * 0.15).clamp(20.0, 40.0);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.local_bar, size: iconSize),

                Flexible(
                  child: Text(
                    selectedBar!.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Center(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BarDetailPage(barId: selectedBar!.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
