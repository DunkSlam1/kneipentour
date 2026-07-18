import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../bars/providers/bar_provider.dart';
import '../../bars/models/bar.dart';
import '../widgets/selected_bar_card.dart';
import '../widgets/bar_marker.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  Bar? selectedBar;
  LatLng? placementPoint;

  @override
  Widget build(BuildContext context) {
    final bars = ref.watch(barProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Karte')),

      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(51.5338, 9.9350),
              initialZoom: 14,

              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),

              onTap: (tapPosition, latLng) {
                setState(() {
                  placementPoint = latLng;
                });
              },
            ),

            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'de.deinprojekt.kneipentour',
              ),

              MarkerLayer(
                markers: [
                  // 👉 BAR MARKER
                  ...bars.map((bar) {
                    final isSelected = selectedBar?.id == bar.id;

                    return Marker(
                      point: LatLng(bar.latitude, bar.longitude),
                      width: isSelected ? 60 : 40,
                      height: isSelected ? 60 : 40,
                      child: BarMarker(
                        bar: bar,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedBar = bar;
                          });
                        },
                      ),
                    );
                  }),

                  // 👉 PLACEMENT MARKER
                  if (placementPoint != null)
                    Marker(
                      point: placementPoint!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 42,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 👉 SELECTED BAR CARD
          if (selectedBar != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SelectedBarCard(bar: selectedBar!),
            ),

          // 👉 DEBUG / PLACEMENT OVERLAY
          if (placementPoint != null)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📍 Placement Marker",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Text("Lat: ${placementPoint!.latitude}"),
                      Text("Lng: ${placementPoint!.longitude}"),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              final text =
                                  "${placementPoint!.latitude}, ${placementPoint!.longitude}";

                              Clipboard.setData(ClipboardData(text: text));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Koordinaten kopiert"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text("Copy"),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                placementPoint = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Clear"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
