import 'package:bible_app/services/journal_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalEntryPage extends StatefulWidget {
  final String?
      journalEntryId; // Accept journalEntryId (nullable for new entries)

  const JournalEntryPage({Key? key, this.journalEntryId}) : super(key: key);

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  final JournalServices journalService = JournalServices();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.journalEntryId != null) {
      _loadJournalEntry();
    }
  }

  Future<void> _loadJournalEntry() async {
    final docSnapshot =
        await journalService.journalEntries.doc(widget.journalEntryId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      titleController.text = data['title'] ?? '';
      bodyController.text = data['content'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journalEntryId == null ? 'New Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Title"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: bodyController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "New Journal Entry"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (titleController.text.trim().isEmpty ||
              bodyController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please enter both a title and a body.')),
            );
            return;
          }

          if (widget.journalEntryId == null) {
            // Create new
            await journalService.createJournalEntry(
              userId: user!.uid,
              title: titleController.text,
              content: bodyController.text,
            );
          } else {
            // Update existing
            await journalService.updateJournalEntry(
              journalEntryId: widget.journalEntryId!,
              title: titleController.text,
              content: bodyController.text,
            );
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
