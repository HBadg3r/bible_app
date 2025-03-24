import 'package:flutter/material.dart';

// Stateless widget that displays the Journal Entry Page
class JournalEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with the page title
      appBar: AppBar(title: Text("Journal Entry Page")),

      // Centered content in the body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple page label
            Text("Journal Entry Page"),

            // Button to return to the previous page (usually Home Page)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Go back one screen in the navigation stack
              },
              child: Text("Back to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
