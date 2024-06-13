// const List<String> words = [
//   'PIZZA',
//   'BREAD'
// ];

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> fetchWordsFromFirebase() async{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try{
    QuerySnapshot snapshot = await _firestore.collection('words').get();
    List<String> words = snapshot.docs.map((e) => e['word'] as String).toList();
    return words;
  }catch (e){
    print("Error fetching words from Firebase: $e");
    return [];
  }
}