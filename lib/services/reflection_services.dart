import 'package:cloud_firestore/cloud_firestore.dart';

class ReflectionServices {
  final CollectionReference reflectionEntries =
      FirebaseFirestore.instance.collection('reflection_entries');

  // Create: add a new reflection
  Future<void> createReflectionEntry({
    required String userId,
    required String tldr,
    required String reflectionText,
    required String journalEntryId,
  }) async {
    await reflectionEntries.add({
      'userId': userId,
      'tldr': tldr,
      'reflectionText': reflectionText,
      'journalEntryId': journalEntryId,
      'pinned': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Find reflection by journalEntryId
  Future<DocumentSnapshot?> getReflectionByJournalId(
      String journalEntryId) async {
    final querySnapshot = await reflectionEntries
        .where('journalEntryId', isEqualTo: journalEntryId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null; // No reflection found
    }
  }

  // Get all pinned reflections for a specific user
  Stream<QuerySnapshot> getPinnedReflections({required String userId}) {
    return reflectionEntries
        .where('userId', isEqualTo: userId)
        .where('pinned', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // Update: Update an existing reflection entry
  Future<void> updateReflectionEntry({
    required String reflectionId,
    String? tldr,
    String? reflectionText,
    bool? pinned,
  }) async {
    final Map<String, dynamic> updates = {};

    if (tldr != null) updates['tldr'] = tldr;
    if (reflectionText != null) updates['reflectionText'] = reflectionText;
    if (pinned != null) updates['pinned'] = pinned;

    updates['updatedAt'] = FieldValue.serverTimestamp();

    await reflectionEntries.doc(reflectionId).update(updates);
  }

  // ReflectionServices.dart

  Future<bool> isReflectionPinned(String reflectionId) async {
    final docSnapshot = await reflectionEntries.doc(reflectionId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return data['pinned'] ?? false; // Default to false if pinned is missing
    } else {
      return false; // If the document doesn't exist, treat as not pinned
    }
  }
}
