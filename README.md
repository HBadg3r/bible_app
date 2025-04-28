# Senior Project Portfolio

## Project Overview
This project is a mobile Bible journaling app built using Flutter and Firebase, designed to help users engage more deeply with scripture through personal reflections, journaling, and verse pinning features. The app provides an accessible, secure, and user-friendly platform for daily Bible study, journaling, and spiritual growth.

## Background
The purpose of building this app was to create a modern tool for Bible readers who want a simple way to document their reflections, prayers, and studies on the go. While many Bible apps exist, few offer customizable journaling features tied directly to scripture. This app fills that gap by integrating journaling, tagging, verse selection, and AI-assisted reflection prompts to encourage deeper spiritual engagement.

## Design Diagrams
![Architecture Diagram](./images/architecture-diagram.png)
![Database Diagram](./images/database-diagram.png)

## Code Snippets
```dart
// Flutter: Example of creating a new journal entry
void createJournalEntry(String title, String content) {
  final newEntry = {
    'title': title,
    'content': content,
    'timestamp': DateTime.now(),
    'tags': [],
  };
  FirebaseFirestore.instance.collection('journalEntries').add(newEntry);
}
