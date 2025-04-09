import 'package:bible_app/pages/manage_tags.dart';
import 'package:bible_app/pages/reflection_page.dart';
import 'package:bible_app/services/journal_services.dart';
import 'package:bible_app/services/reflection_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'journal_entry_page.dart';

final JournalServices journalService = JournalServices();
final ReflectionServices reflectionService = ReflectionServices();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010), // Dark background
      appBar: AppBar(
        title: const Text(
          "Bible Journaling App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Placeholder for settings button functionality
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Add this: White "Pinned Reflections" text
            const Text(
              "Pinned Reflections",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 🔥 Then the green outlined container
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                border: Border.all(color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: reflectionService.getPinnedReflections(
                    userId: FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reflections = snapshot.data!.docs;

                  if (reflections.isEmpty) {
                    return const Text(
                      "No pinned reflections yet.",
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  return Column(
                    children: reflections.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReflectionEntryPage(
                                journalEntryId: data['journalEntryId'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                data['tldr'] ?? 'No Summary',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Pinned Bible Verses Section
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity, // Ensures it takes the full width
              constraints: const BoxConstraints(
                minHeight: 60, // Minimum height for 2-3 lines of text
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF101010), // Gray fill
                border: Border.all(
                    color: Colors.greenAccent), // Green accent border
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                "Pinned Bible Verses: John 3:16, Psalms 23:4",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),

            // Search Box, Reflection Toggle, View Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: searchController,
                  onSubmitted: (value) {
                    setState(() {
                      searchText = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                )),
                const SizedBox(width: 16),
                // Reflection Toggle Icon
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.greenAccent),
                  onPressed: () {
                    // Placeholder for reflection toggle functionality
                  },
                ),
                const SizedBox(width: 16),
                // View Options Icon
                IconButton(
                  icon:
                      const Icon(Icons.view_module, color: Colors.greenAccent),
                  onPressed: () {
                    // Placeholder for view options functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Header Section for Journal Entries
            const Text(
              "User Journal Entries / Reflections",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Grid of Entries
            Expanded(
              child: searchText.isEmpty
                  ? StreamBuilder<QuerySnapshot>(
                      stream: journalService.getJournalEntriesByUserId(
                          userId: FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong',
                                  style: TextStyle(color: Colors.white)));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return buildJournalEntriesList(snapshot.data!.docs);
                      },
                    )
                  : FutureBuilder<List<DocumentSnapshot>>(
                      future: journalService.searchJournalEntries(
                        FirebaseAuth.instance.currentUser!.uid,
                        searchText,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong',
                                  style: TextStyle(color: Colors.white)));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return buildJournalEntriesList(snapshot.data!);
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JournalEntryPage()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget buildJournalEntriesList(List<DocumentSnapshot> journalEntries) {
  return ListView.builder(
    itemCount: journalEntries.length,
    itemBuilder: (context, index) {
      var doc = journalEntries[index];
      var entry = doc.data() as Map<String, dynamic>;
      String docId = doc.id;
      String title = entry['title'] ?? 'Untitled';
      Timestamp createdAt = entry['createdAt'] ?? Timestamp.now();
      DateTime createdDate = createdAt.toDate();

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.grey[800],
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Date: ${createdDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this entry?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            await journalService
                                .deleteJournalEntry(docId); // Actually delete
                            Navigator.of(context)
                                .pop(); // Close dialog after delete
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (value == 'manage_tags') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageTagsPage(journalEntryId: docId),
                  ),
                );
              } else if (value == 'view_reflection') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReflectionEntryPage(journalEntryId: docId),
                  ),
                );
              } else if (value == 'create_copy') {
                // TODO: Implement create copy
              } else if (value == 'move') {
                // TODO: Implement move
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem<String>(
                value: 'manage_tags',
                child: Text('Manage Tag(s)'),
              ),
              const PopupMenuItem<String>(
                value: 'view_reflection',
                child: Text('View Associated Reflection'),
              ),
              const PopupMenuItem<String>(
                value: 'create_copy',
                child: Text('Create Copy'),
              ),
              const PopupMenuItem<String>(
                value: 'move',
                child: Text('Move'),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEntryPage(journalEntryId: docId),
              ),
            );
          },
        ),
      );
    },
  );
}
