import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordhunt/pages/home_page.dart';

calculateStats({required bool gameWon}) async {
  int gamesPlayed = 0,
      gamesWon = 0,
      windPercentage = 0,
      currentStreak = 0,
      maxStreak = 0;

  // final stats = await getStats();
  // if (stats != null) {
  //   gamesPlayed = int.parse(stats[0]);
  //   gamesWon = int.parse(stats[1]);
  //   windPercentage = int.parse(stats[2]);
  //   currentStreak = int.parse(stats[3]);
  //   maxStreak = int.parse(stats[4]);
  // }

  final stats = await getStatsFromFirestore();
  if (stats != null) {
    gamesPlayed = int.parse(stats[0]);
    gamesWon = int.parse(stats[1]);
    windPercentage = int.parse(stats[2]);
    currentStreak = int.parse(stats[3]);
    maxStreak = int.parse(stats[4]);
  }

  gamesPlayed++;

  if (gameWon) {
    gamesWon++;
    currentStreak++;
  } else {
    currentStreak = 0;
  }

  if (currentStreak > maxStreak) {
    maxStreak = currentStreak;
  }

  windPercentage = ((gamesWon / gamesPlayed) * 100).toInt();

  storeStats(
      gamesPlayed.toString(),
      gamesWon.toString(),
      windPercentage.toString(),
      currentStreak.toString(),
      maxStreak.toString());
}

Future<List<String>?> getStats() async {
  final prefs = await SharedPreferences.getInstance();
  final stats = prefs.getStringList('stats');
  if (stats != null) {
    return stats;
  } else {
    return null;
  }
}

Future<List<String>?> getStatsFromFirestore() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot statsDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('user-stats') // Fixed document ID
          .get();

      if (statsDoc.exists) {
        List<String> stats = [
          statsDoc['gamesPlayed'],
          statsDoc['gamesWon'],
          statsDoc['winPercentage'],
          statsDoc['currentStreak'],
          statsDoc['maxStreak'],
        ];
        return stats;
      } else {
        print('Stats document does not exist for user: ${user.uid}');
        return null;
      }
    } catch (e) {
      print('Error retrieving stats: $e');
      return null;
    }
  } else {
    print('User is not authenticated.');
    return null;
  }
}

void storeStats(String gamesPlayed, String gamesWon, String winPercentage,
    String currentStreak, String maxStreak) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    saveUserStats(
        user.uid,
        int.parse(gamesPlayed),
        int.parse(gamesWon),
        double.parse(winPercentage),
        int.parse(currentStreak),
        int.parse(maxStreak),
        HomePage.countryCodeIso);
    CollectionReference statsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('stats');

    final statsDoc = statsRef.doc('user-stats');

    await statsDoc.set({
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'winPercentage': winPercentage,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak
    });
  } else {
    print("user is null");
  }
}

// Save or update user statistics
Future<void> saveUserStats(
    String userId,
    int gamesPlayed,
    int gamesWon,
    double winPercentage,
    int currentStreak,
    int maxStreak,
    String countryCode) async {
  try {
    await FirebaseFirestore.instance.collection('alluserstats').doc(userId).set(
        {
          'gamesPlayed': gamesPlayed,
          'gamesWon': gamesWon,
          'winPercentage': winPercentage,
          'currentStreak': currentStreak,
          'maxStreak': maxStreak,
          'countryCode': countryCode
        },
        SetOptions(
            merge: true)); // Merge the data if the document already exists
  } catch (e) {
    print("Error saving user stats: $e");
  }
}
