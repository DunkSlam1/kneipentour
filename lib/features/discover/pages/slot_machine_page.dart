import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bars/models/bar.dart';
import '../../bars/providers/bar_provider.dart';

import '../models/bar_pick_filter.dart';
import '../models/discover_card_state.dart';
import '../services/bar_picker_service.dart';
import '../widgets/rolling_bar_card.dart';
import '../widgets/slot_machine_lever.dart';
import '../widgets/slot_machine_filters.dart';

class SlotMachinePage extends ConsumerStatefulWidget {
  const SlotMachinePage({super.key});

  @override
  ConsumerState<SlotMachinePage> createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends ConsumerState<SlotMachinePage> {
  final BarPickerService barPicker = BarPickerService();

  Bar? selectedBar;

  DiscoverCardState cardState = DiscoverCardState.idle;

  bool isRolling = false;

  List<String> rollingNames = [];

  List<Bar> rollingBars = [];

  int rollingIndex = 0;

  int winnerIndex = 0;

  int counter = 0;

  static const int maxRollSteps = 30;

  Timer? rollingTimer;

  BarPickFilter selectedOpeningFilter = BarPickFilter.all;

  bool onlyUnvisited = false;

  void pickBar(List<Bar> bars) {
    final candidates = barPicker.getCandidates(
      bars,
      selectedOpeningFilter,
      onlyUnvisited: onlyUnvisited,
    );

    if (candidates.isEmpty) {
      return;
    }

    final random = Random();

    final finalBar = candidates[random.nextInt(candidates.length)];

    rollingBars = List<Bar>.from(candidates)..shuffle(random);

    winnerIndex = rollingBars.indexOf(finalBar);

    setState(() {
      isRolling = true;
      selectedBar = null;
      cardState = DiscoverCardState.rolling;
      rollingIndex = 0;
      counter = 0;
    });

    void rollStep() {
      if (counter >= maxRollSteps) {
        setState(() {
          rollingNames = [
            rollingBars[(winnerIndex - 1 + rollingBars.length) %
                    rollingBars.length]
                .name,

            rollingBars[winnerIndex].name,

            rollingBars[(winnerIndex + 1) % rollingBars.length].name,
          ];
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            isRolling = false;
            rollingNames = [];
            selectedBar = finalBar;
            cardState = DiscoverCardState.winner;
          });
        });

        return;
      }

      final first = rollingBars[rollingIndex % rollingBars.length];

      final second = rollingBars[(rollingIndex + 1) % rollingBars.length];

      final third = rollingBars[(rollingIndex + 2) % rollingBars.length];

      setState(() {
        rollingNames = [first.name, second.name, third.name];
      });

      rollingIndex++;

      counter++;

      final progress = counter / maxRollSteps;

      Future.delayed(
        Duration(milliseconds: (40 + (progress * progress * 400)).round()),
        rollStep,
      );
    }

    rollStep();
  }

  @override
  void dispose() {
    rollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bars = ref.watch(barProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('🎰 Slot Machine')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            SlotMachineFilters(
              selectedFilter: selectedOpeningFilter,
              onlyUnvisited: onlyUnvisited,
              disabled: isRolling,

              onFilterChanged: (filter) {
                setState(() {
                  selectedOpeningFilter = filter;
                });
              },

              onUnvisitedChanged: (value) {
                setState(() {
                  onlyUnvisited = value;
                });
              },
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 300,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: RollingBarCard(
                      names: isRolling ? rollingNames : [],
                      selectedBar: selectedBar,
                      cardState: cardState,
                    ),
                  ),

                  Positioned(
                    bottom: -15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SlotMachineLever(
                        enabled: !isRolling,
                        onPressed: () => pickBar(bars),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
