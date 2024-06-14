import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Global Leaderboard"),
      ),
      body: StreamBuilder(
        stream: _db
            .collection('alluserstats')
            .orderBy('winPercentage', descending: true)
            .limit(10) // Limit to top 10 players
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: SizedBox(
                  width: 30,
                  height: 20,
                  child: CountryIcons.getSvgFlag(data['countryCode'] ?? 'CRO'),
                ),
                title: Text("Player ${index + 1}"),
                subtitle: Text("Win Percentage: ${data['winPercentage']}%"),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Games Played: ${data['gamesPlayed']}"),
                    Text("Games Won: ${data['gamesWon']}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
