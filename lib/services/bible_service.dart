// lib/services/bible_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BibleService {
  final CollectionReference pinnedVerses =
      FirebaseFirestore.instance.collection('pinned_verses');

  Future<String> fetchVerse(
      {required String book,
      required String chapter,
      required String verse}) async {
    final query = '$book+$chapter:$verse';
    final url = Uri.parse('https://bible-api.com/$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return '${data['reference']} — ${data['text'].trim()}';
    } else {
      throw Exception('Failed to load verse');
    }
  }

  Future<void> pinVerse({
    required String book,
    required String chapter,
    required String verse,
    required String text,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No logged-in user');

    await pinnedVerses.add({
      'userId': user.uid,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unpinVerse({
    required String book,
    required String chapter,
    required String verse,
  }) async {
    final querySnapshot = await pinnedVerses
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('book', isEqualTo: book)
        .where('chapter', isEqualTo: chapter)
        .where('verse', isEqualTo: verse)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }

  Future<bool> isVersePinned({
    required String book,
    required String chapter,
    required String verse,
  }) async {
    final querySnapshot = await pinnedVerses
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('book', isEqualTo: book)
        .where('chapter', isEqualTo: chapter)
        .where('verse', isEqualTo: verse)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
