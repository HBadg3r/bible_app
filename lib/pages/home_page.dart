import 'package:bible_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'journal_entry_page.dart';
import 'openai_page.dart';
import 'reflection_page.dart';
import 'bible_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JournalEntryPage()));
              },
              child: Text("Go to Journal Entry Page"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OpenAIPage()));
              },
              child: Text("Go to OpenAI Conversation Page"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReflectionPage()));
              },
              child: Text("Go to Reflection Entry Page"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BiblePage()));
              },
              child: Text("Go to Bible Page"),
            ),
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
