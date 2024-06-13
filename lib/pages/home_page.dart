import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordhunt/components/grid.dart';
import 'package:wordhunt/components/keyboard_row.dart';
import 'package:wordhunt/components/stats_box.dart';
import 'package:wordhunt/constants/words.dart';
import 'package:wordhunt/pages/settings.dart';
import 'package:wordhunt/providers/controller.dart';
import 'package:wordhunt/data/keys_map.dart';
import 'package:wordhunt/providers/theme_provider.dart';
import 'package:wordhunt/utils/quick_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _word;

  @override
  void initState() {
    initializeWord();
    super.initState();
  }

  void initializeWord() async {
    List<String> words = await fetchWordsFromFirebase();
    if (words.isNotEmpty) {
      final randomIndex = Random().nextInt(words.length);
      _word = words[randomIndex];

      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        Provider.of<Controller>(context, listen: false)
            .setCorrectWord(word: _word);
      });
    } else {
      print("No words fetched from Firebase");
      // fallback to local words
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordHunt'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Settings()));
            },
            icon: const Icon(Icons.settings)),
        actions: [
          Consumer<Controller>(
            builder: (_, notifier, __) {
              if (notifier.notEnoughLetters) {
                runQuickBox(context: context, message: 'Nema dovoljno slova!');
              }
              if (notifier.gameCompleted) {
                if (notifier.gameWon) {
                  if (notifier.currentRow == 6) {
                    runQuickBox(context: context, message: 'Jedva!');
                  } else {
                    runQuickBox(context: context, message: 'Odlicno!');
                  }
                } else {
                  runQuickBox(
                      context: context,
                      message: "Tocna rijec je: ${notifier.correctWord}");
                }
                Future.delayed(
                  const Duration(milliseconds: 1500),
                  () {
                    if (mounted) {
                      showDialog(
                          context: context, builder: (_) => const StatsBox());
                    }
                  },
                );
              }
              return IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (_) => StatsBox());
                  },
                  icon: Icon(Icons.bar_chart_outlined));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 2,
          ),
          const Expanded(
            flex: 7,
            child: Grid(),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: const [
                KeyboardRow(min: 1, max: 10),
                KeyboardRow(min: 11, max: 19),
                KeyboardRow(min: 20, max: 29),
              ],
            ),
          )
        ],
      ),
    );
  }
}
