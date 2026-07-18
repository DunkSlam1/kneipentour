import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/providers/bar_provider.dart';
import '../../bars/providers/bar_review_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barNotifier = ref.read(barProvider.notifier);
    final reviewNotifier = ref.read(barReviewProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // DARSTELLUNG
          const Text(
            'Darstellung',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: RadioGroup<ThemeMode>(
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  notifier.setThemeMode(value);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text('System'),
                    subtitle: Text('Verwendet die Geräteeinstellung'),
                    value: ThemeMode.system,
                  ),

                  RadioListTile<ThemeMode>(
                    title: Text('Hell'),
                    value: ThemeMode.light,
                  ),

                  RadioListTile<ThemeMode>(
                    title: Text('Dunkel'),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // DATENVERWALTUNG
          const Text(
            'Datenverwaltung',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Alle Daten löschen'),
              subtitle: const Text('Entfernt alle gespeicherten Kneipen-Daten'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Alle Daten löschen?'),

                      content: const Text(
                        'Möchtest du wirklich alle gespeicherten '
                        'Kneipen-Daten entfernen?\n\n'
                        'Diese Aktion kann nicht rückgängig gemacht werden.',
                      ),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Abbrechen'),
                        ),

                        FilledButton(
                          onPressed: () async {
                            await barNotifier.clearPersonalData();
                            await reviewNotifier.clearReviews();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Löschen'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ÜBER
          const Text(
            'Über KneipenTour',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KneipenTour 🍻',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Deine persönliche Sammlung von Kneipen. '
                    'Entdecke neue Orte, halte deine Besuche fest '
                    'und behalte deine Favoriten im Blick.',
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
