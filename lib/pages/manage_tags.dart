import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bible_app/services/journal_services.dart'; // Adjust if needed

class ManageTagsPage extends StatelessWidget {
  final String journalEntryId; // Required
  final JournalServices journalService = JournalServices();

  ManageTagsPage({Key? key, required this.journalEntryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final TextEditingController tagController =
                  TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add New Tag'),
                    content: TextField(
                      controller: tagController,
                      decoration: const InputDecoration(
                        hintText: 'Enter tag name',
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Add'),
                        onPressed: () async {
                          final newTag = tagController.text.trim();
                          if (newTag.isNotEmpty) {
                            await journalService.addTagToJournalEntry(
                              journalEntryId:
                                  journalEntryId, // <-- Pass the correct docId
                              tagName: newTag,
                            );
                          }
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFF101010),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Green Accent Line Separator
            Container(
              height: 2,
              color: Colors.greenAccent,
              margin: const EdgeInsets.only(bottom: 16),
            ),

            // Live Stream of Tags
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: journalService.getJournalEntryById(
                    journalEntryId: journalEntryId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Something went wrong',
                            style: TextStyle(color: Colors.white)));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  final List<dynamic> tags = data?['tags'] ?? [];

                  if (tags.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tags yet.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      String tag = tags[index];
                      final TextEditingController tagController =
                          TextEditingController(text: tag);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.grey[800],
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: TextField(
                            controller: tagController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onSubmitted: (newValue) async {
                              // Only update if the tag text actually changed
                              if (newValue.trim().isNotEmpty &&
                                  newValue.trim() != tag) {
                                await journalService.deleteTagFromJournalEntry(
                                  journalEntryId: journalEntryId,
                                  tagName: tag, // Remove old tag
                                );
                                await journalService.addTagToJournalEntry(
                                  journalEntryId: journalEntryId,
                                  tagName:
                                      newValue.trim(), // Add new updated tag
                                );
                              }
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this tag?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        onPressed: () async {
                                          await journalService
                                              .deleteTagFromJournalEntry(
                                            journalEntryId: journalEntryId,
                                            tagName: tag,
                                          );
                                          Navigator.of(context)
                                              .pop(); // Close dialog after delete
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
