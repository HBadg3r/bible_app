// lib/pages/bible_page.dart

import 'package:bible_app/services/bible_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  final BibleService bibleService = BibleService();

  final TextEditingController bookController = TextEditingController();
  String selectedChapter = '1';
  String selectedVerse = '1';

  String? fetchedVerse;
  bool isLoading = false;
  bool isPinned = false;

  final List<String> chapterOptions =
      List.generate(150, (index) => '${index + 1}');
  final List<String> verseOptions =
      List.generate(176, (index) => '${index + 1}'); // Max 176 (Psalm 119)

  Future<void> searchVerse() async {
    final book = bookController.text.trim();

    if (book.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a book name')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await bibleService.fetchVerse(
        book: book,
        chapter: selectedChapter,
        verse: selectedVerse,
      );

      final pinned = await bibleService.isVersePinned(
        book: book,
        chapter: selectedChapter,
        verse: selectedVerse,
      );

      setState(() {
        fetchedVerse = result;
        isPinned = pinned;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> togglePin() async {
    final book = bookController.text.trim();

    if (book.isEmpty || fetchedVerse == null) {
      return;
    }

    try {
      if (isPinned) {
        await bibleService.unpinVerse(
          book: book,
          chapter: selectedChapter,
          verse: selectedVerse,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verse unpinned!')),
        );
      } else {
        await bibleService.pinVerse(
          book: book,
          chapter: selectedChapter,
          verse: selectedVerse,
          text: fetchedVerse!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verse pinned!')),
        );
      }

      setState(() {
        isPinned = !isPinned;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            const Text('Bible Search', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Book Input
            TextField(
              controller: bookController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Book (e.g. John)',
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dropdowns + Search and Pin buttons
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedChapter,
                    dropdownColor: const Color(0xFF101010),
                    decoration: const InputDecoration(
                      labelText: 'Chapter',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: chapterOptions
                        .map((chapter) => DropdownMenuItem(
                              value: chapter,
                              child: Text(chapter),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedChapter = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedVerse,
                    dropdownColor: const Color(0xFF101010),
                    decoration: const InputDecoration(
                      labelText: 'Verse',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: verseOptions
                        .map((verse) => DropdownMenuItem(
                              value: verse,
                              child: Text(verse),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVerse = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isLoading ? null : searchVerse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: fetchedVerse == null ? null : togglePin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPinned ? Colors.redAccent : Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  child: Text(isPinned ? 'Unpin' : 'Pin'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display fetched verse
            if (fetchedVerse != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SelectableText(
                        fetchedVerse!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: fetchedVerse!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verse copied!')),
                        );
                      },
                      icon: const Icon(Icons.copy, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
