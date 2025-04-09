import 'package:cloud_firestore/cloud_firestore.dart';

class JournalServices {
  final CollectionReference journalEntries =
      FirebaseFirestore.instance.collection('journal_entries');

  // Create: add a new entry
  Future<void> createJournalEntry({
    required String userId,
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    await journalEntries.add({
      'userId': userId,
      'title': title,
      'content': content,
      'tags': tags ?? [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Read: Get entry from database
  Stream<QuerySnapshot> getJournalEntriesByUserId({required String userId}) {
    final journalStream = journalEntries
        .where('userId', isEqualTo: userId) // 👈 Filter where 'userId' matches
        .orderBy('updatedAt', descending: true)
        .snapshots();

    return journalStream;
  }

  // Read: Get a single journal entry by its ID
  Stream<DocumentSnapshot> getJournalEntryById(
      {required String journalEntryId}) {
    final journalEntryStream = journalEntries.doc(journalEntryId).snapshots();

    return journalEntryStream;
  }

  // Update: update an existing journal entry
  Future<void> updateJournalEntry({
    required String journalEntryId,
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(), // Always update this
    };

    if (title != null) updates['title'] = title;
    if (content != null) updates['content'] = content;
    if (tags != null) updates['tags'] = tags;

    await journalEntries.doc(journalEntryId).update(updates);
  }

  // Delete: Delete notes from a given doc id
  Future<void> deleteJournalEntry(String docId) {
    return journalEntries.doc(docId).delete();
  }

  // Add: Append a new tag to existing tags array
  Future<void> addTagToJournalEntry({
    required String journalEntryId,
    required String tagName,
  }) async {
    await journalEntries.doc(journalEntryId).update({
      'tags': FieldValue.arrayUnion([tagName]),
      'updatedAt':
          FieldValue.serverTimestamp(), // Optionally update the timestamp
    });
  }

  // Delete: Remove a tag from the existing tags array
  Future<void> deleteTagFromJournalEntry({
    required String journalEntryId,
    required String tagName,
  }) async {
    await journalEntries.doc(journalEntryId).update({
      'tags': FieldValue.arrayRemove([tagName]),
      'updatedAt':
          FieldValue.serverTimestamp(), // Optionally update the timestamp
    });
  }

  // Search: Search journal entries by both title and tags
  Future<List<DocumentSnapshot>> searchJournalEntries(
      String userId, String searchText) async {
    final titleQuery = await FirebaseFirestore.instance
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .where('title', isGreaterThanOrEqualTo: searchText)
        .where('title', isLessThanOrEqualTo: searchText + '\uf8ff')
        .get();

    final tagQuery = await FirebaseFirestore.instance
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .where('tags', arrayContains: searchText)
        .get();

    // Merge results
    final allDocs = {
      ...titleQuery.docs,
      ...tagQuery.docs
    }; // Using a Set to auto-remove duplicates
    return allDocs.toList();
  }
}
