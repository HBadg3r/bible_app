import 'package:bible_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'journal_entry_page.dart';
import 'openai_page.dart';
import 'reflection_page.dart';
import 'bible_page.dart';

// Stateless widget that serves as the main dashboard or landing screen
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: Text("Home Page")),

      // Centered column of buttons for navigation
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Page"),

            // Navigate to Journal Entry Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JournalEntryPage()),
                );
              },
              child: Text("Go to Journal Entry Page"),
            ),

            // Navigate to OpenAI Conversation Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OpenAIPage()),
                );
              },
              child: Text("Go to OpenAI Conversation Page"),
            ),

            // Navigate to Reflection Entry Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReflectionPage()),
                );
              },
              child: Text("Go to Reflection Entry Page"),
            ),

            // Navigate to Bible Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BiblePage()),
                );
              },
              child: Text("Go to Bible Page"),
            ),

            // Navigate to Profile Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: Text("Go to Profile Page"),
            ),
          ],
        ),
      ),
    );
  }
}
