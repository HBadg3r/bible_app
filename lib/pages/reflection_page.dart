import 'package:bible_app/pages/journal_entry_page.dart';
import 'package:bible_app/services/reflection_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReflectionEntryPage extends StatefulWidget {
  final String journalEntryId;

  const ReflectionEntryPage({Key? key, required this.journalEntryId})
      : super(key: key);

  @override
  _ReflectionEntryPageState createState() => _ReflectionEntryPageState();
}

class _ReflectionEntryPageState extends State<ReflectionEntryPage> {
  final ReflectionServices reflectionService = ReflectionServices();
  final user = FirebaseAuth.instance.currentUser;

  final tldrController = TextEditingController();
  final reflectionTextController = TextEditingController();

  bool isPinned = false; // Track pinned state here

  Future<DocumentReference> _getOrCreateReflection() async {
    final existingReflection =
        await reflectionService.getReflectionByJournalId(widget.journalEntryId);

    if (existingReflection != null) {
      var data = existingReflection.data() as Map<String, dynamic>;
      tldrController.text = data['tldr'] ?? '';
      reflectionTextController.text = data['reflectionText'] ?? '';
      isPinned = data['pinned'] ?? false; // 🔥 Initialize pinned state
      return existingReflection.reference;
    } else {
      final newDoc = await reflectionService.reflectionEntries.add({
        'userId': user!.uid,
        'journalEntryId': widget.journalEntryId,
        'tldr': '',
        'reflectionText': '',
        'pinned': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return newDoc;
    }
  }

  late Future<DocumentReference> _reflectionFuture;

  @override
  void initState() {
    super.initState();
    _reflectionFuture = _getOrCreateReflection(); // Cache the Future
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentReference>(
      future: _reflectionFuture,
      builder: (context, reflectionRefSnapshot) {
        if (!reflectionRefSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final reflectionDoc = reflectionRefSnapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Reflection'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await reflectionService.updateReflectionEntry(
                      reflectionId: reflectionDoc.id,
                      pinned: !isPinned, // Toggle pinned
                    );

                    setState(() {
                      isPinned = !isPinned; // Rebuild the button
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isPinned
                            ? 'Reflection pinned successfully'
                            : 'Reflection unpinned successfully'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isPinned ? 'Unpin' : 'Pin',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: tldrController,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "TL;DR (Summary)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: reflectionTextController,
                      style: const TextStyle(fontSize: 18),
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "New Reflection",
                      ),
                    ),
                    const SizedBox(
                        height:
                            80), // Give some extra space so text fields don't overlap the button
                  ],
                ),
              ),

              // 👇 Button pinned to bottom center
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JournalEntryPage(
                            journalEntryId: widget.journalEntryId,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Go to Journal Entry",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tldrController.text.trim().isEmpty ||
                  reflectionTextController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Please enter both a TL;DR and a Reflection.'),
                  ),
                );
                return;
              }

              await reflectionDoc.update({
                'tldr': tldrController.text.trim(),
                'reflectionText': reflectionTextController.text.trim(),
                'updatedAt': FieldValue.serverTimestamp(),
              });

              Navigator.of(context).pop();
            },
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}
