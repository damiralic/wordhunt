import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:wordhunt/pages/home_page.dart';
import 'package:wordhunt/pages/leaderboard_page.dart';
import 'package:wordhunt/utils/calculate_stats.dart';
import 'package:wordhunt/components/stats_tile.dart';
import 'package:wordhunt/constants/answer_stages.dart';
import 'package:wordhunt/data/keys_map.dart';
import 'package:wordhunt/main.dart';

class StatsBox extends StatelessWidget {
  StatsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: Icon(Icons.clear)),
          Expanded(
              child: Text(
            "STATISTICS",
            textAlign: TextAlign.center,
          )),
          Center(
              child: SizedBox(
            width: 50,
            height: 30,
            child: CountryIcons.getSvgFlag(HomePage.countryCodeIso),
          )),
          Expanded(
            child: FutureBuilder(
              future: getStatsFromFirestore(),
              builder: (context, snapshot) {
                List<String> results = ['0', '0', '0', '0', '0'];
                if (snapshot.hasData) {
                  results = snapshot.data as List<String>;
                }
                return Row(
                  children: [
                    StatsTile(
                      heading: "Played",
                      value: int.parse(results[0]),
                    ),
                    StatsTile(
                      heading: "Win %",
                      value: int.parse(results[2]),
                    ),
                    StatsTile(
                      heading: "Current\nStreak",
                      value: int.parse(results[3]),
                    ),
                    StatsTile(
                      heading: "Max\nStreak",
                      value: int.parse(results[4]),
                    ),
                  ],
                );
              },
            ),
          ),
          const Expanded(
            flex: 5,
            child: Divider(
              height: 3,
              thickness: 2,
            ),
          ),
          ListTile(
            title: const Text('Pregledaj Tablicu'),
            onTap: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LeaderboardPage()));
            },
          ),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 186, 188, 235),
                  ),
                  onPressed: () {
                    keysMap.updateAll(
                        (key, value) => value = AnswerStage.notAnswered);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (route) => false);
                  },
                  child: Text("Replay",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ))))
        ],
      ),
    );
  }
}
