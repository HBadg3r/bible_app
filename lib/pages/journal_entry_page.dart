import 'dart:convert';

import 'package:bible_app/services/journal_services.dart';
import 'package:bible_app/pages/bible_page.dart';
import 'package:bible_app/pages/openai_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class JournalEntryPage extends StatefulWidget {
  final String?
      journalEntryId; // Accept journalEntryId (nullable for new entries)

  const JournalEntryPage({Key? key, this.journalEntryId}) : super(key: key);

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final titleController = TextEditingController();
  QuillController _quillController = QuillController.basic();

  final JournalServices journalService = JournalServices();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();

    if (widget.journalEntryId != null) {
      _loadJournalEntry();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _loadJournalEntry() async {
    final docSnapshot =
        await journalService.journalEntries.doc(widget.journalEntryId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      titleController.text = data['title'] ?? '';

      if (data['content'] != null && data['content'].isNotEmpty) {
        _quillController = QuillController(
          document: Document.fromJson(jsonDecode(data['content'])),
          selection: const TextSelection.collapsed(offset: 0),
        );
        setState(() {}); // Rebuild widget with loaded document
      }
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
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  QuillEditor.basic(
                    controller: _quillController,
                    config: const QuillEditorConfig(),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'saveButton',
                          mini: true,
                          onPressed: () async {
                            final contentJson = jsonEncode(
                                _quillController.document.toDelta().toJson());
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a title.')),
                              );
                              return;
                            }
                            if (widget.journalEntryId == null) {
                              await journalService.createJournalEntry(
                                userId: user!.uid,
                                title: titleController.text,
                                content: contentJson,
                              );
                            } else {
                              await journalService.updateJournalEntry(
                                journalEntryId: widget.journalEntryId!,
                                title: titleController.text,
                                content: contentJson,
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.save),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton(
                          heroTag: 'chatButton',
                          mini: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenaiChatPage()),
                            );
                          },
                          child: const Icon(Icons.chat),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton(
                          // NEW: BIBLE button
                          heroTag: 'bibleButton',
                          mini: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BiblePage()), // 👈 Don't forget to import BiblePage
                            );
                          },
                          child: const Icon(
                              Icons.book), // Bible icon (you can change)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            QuillSimpleToolbar(
              controller: _quillController,
              config: const QuillSimpleToolbarConfig(),
            ),
          ],
        ),
      ),
    );
  }
}
