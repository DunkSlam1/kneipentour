import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/providers/bar_provider.dart';
import '../../bars/providers/bar_review_provider.dart';
import '../providers/settings_provider.dart';
import '../../sync/providers/sync_provider.dart';
import '../../sync/utils/sync_id_generator.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barNotifier = ref.read(barProvider.notifier);
    final reviewNotifier = ref.read(barReviewProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final syncAsync = ref.watch(syncProvider);
    final syncNotifier = ref.read(syncProvider.notifier);
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

          const SizedBox(height: 24),

          // SYNCHRONISATION
          const Text(
            'Synchronisation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: syncAsync.when(
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },

                error: (error, stack) {
                  return Text('Fehler: $error');
                },

                data: (sync) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sync.isConnected
                            ? 'Tour verbunden'
                            : 'Keine Tour verbunden',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (sync.isConnected)
                        Text('Tour-Code: ${sync.tourId}')
                      else
                        const Text(
                          'Erstelle später eine gemeinsame Tour '
                          'oder trete einer bestehenden bei.',
                        ),

                      const SizedBox(height: 12),

                      if (sync.isConnected)
                        FilledButton.icon(
                          icon: const Icon(Icons.link_off),
                          label: const Text('Verbindung löschen'),
                          onPressed: () {
                            syncNotifier.clearSync();
                          },
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton.icon(
                              icon: const Icon(Icons.add_link),
                              label: const Text('Tour erstellen'),
                              onPressed: () {
                                final id = SyncIdGenerator.generate();

                                syncNotifier.createTour(id);
                              },
                            ),

                            const SizedBox(height: 8),

                            OutlinedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Tour beitreten'),
                              onPressed: () {
                                _showJoinDialog(context, syncNotifier);
                              },
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

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

  void _showJoinDialog(BuildContext context, SyncNotifier syncNotifier) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tour beitreten'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tour-Code',
              hintText: 'Code eingeben',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abbrechen'),
            ),

            FilledButton(
              onPressed: () {
                final code = controller.text.trim().toUpperCase();

                if (code.isEmpty) {
                  return;
                }

                syncNotifier.joinTour(code);

                Navigator.pop(context);
              },
              child: const Text('Verbinden'),
            ),
          ],
        );
      },
    );
  }
}
