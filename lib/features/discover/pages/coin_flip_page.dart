import 'package:flutter/material.dart';
import 'dart:math';

import '../../bars/models/bar.dart';
import '../../bars/repositories/bar_repository.dart';
import '../widgets/coin_widget.dart';

class CoinFlipPage extends StatefulWidget {
  const CoinFlipPage({super.key});

  @override
  State<CoinFlipPage> createState() => _CoinFlipPageState();
}

class _CoinFlipPageState extends State<CoinFlipPage>
    with SingleTickerProviderStateMixin {
  Bar? beerBar;
  Bar? cocktailBar;
  Bar? winner;
  bool? beerWinner;
  bool get isFlipping => _coinController.isAnimating;
  late AnimationController _coinController;
  late Animation<double> _coinAnimation;

  void _flipCoin() {
    if (beerBar == null || cocktailBar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte zuerst beide Seiten auswählen.')),
      );
      return;
    }

    final result = Random().nextBool();

    setState(() {
      beerWinner = result;
      winner = null;
    });

    _coinController.reset();

    _coinController.forward().whenComplete(() {
      if (!mounted) return;

      setState(() {
        winner = result ? beerBar : cocktailBar;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _coinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _coinAnimation = CurvedAnimation(
      parent: _coinController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _coinController.dispose();
    super.dispose();
  }

  void _selectBar(bool beerSide) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: BarRepository.bars.map((bar) {
            return ListTile(
              title: Text(bar.name),
              onTap: () {
                setState(() {
                  if (beerSide) {
                    beerBar = bar;
                  } else {
                    cocktailBar = bar;
                  }
                });

                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Münzwurf 🪙')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Text(
              'Münzwurf',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Weise jeder Seite eine Kneipe zu und lass die Münze entscheiden.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            // Bierseite
            Card(
              elevation: 4,

              child: ListTile(
                leading: const Text('🍺', style: TextStyle(fontSize: 30)),

                title: const Text(
                  'Bierseite',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(beerBar?.name ?? 'Noch keine Kneipe ausgewählt'),

                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.primary,
                ),

                onTap: () {
                  _selectBar(true);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Münze
            CoinWidget(
              animation: _coinAnimation,
              showBeerSide: beerWinner ?? true,
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: isFlipping ? null : _flipCoin,

              icon: const Icon(Icons.casino),

              label: const Text('Münze werfen'),
            ),
            if (winner != null) ...[
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '🎉 Gewonnen hat:\n${winner!.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Cocktailseite
            Card(
              elevation: 4,

              child: ListTile(
                leading: const Text('🍸', style: TextStyle(fontSize: 30)),

                title: const Text(
                  'Cocktailseite',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  cocktailBar?.name ?? 'Noch keine Kneipe ausgewählt',
                ),

                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.primary,
                ),

                onTap: () {
                  _selectBar(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
