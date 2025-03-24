import 'package:flutter/material.dart';

// Stateless widget that represents the OpenAI conversation page
class OpenAIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with the page title
      appBar: AppBar(title: Text("OpenAI Conversation Page")),

      // Body centered vertically and horizontally
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Page label
            Text("OpenAI Conversation Page"),

            // Button to return to the previous screen (usually Home Page)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Pops this page off the navigation stack
              },
              child: Text("Back to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
