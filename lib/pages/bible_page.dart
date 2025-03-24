import 'package:flutter/material.dart';

// A simple stateless widget for the Bible Page
class BiblePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar with title
      appBar: AppBar(title: Text("Bible Page")),

      // Centered body content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Page label
            Text("Bible Page"),

            // Button to go back to the previous page (typically HomePage)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Pops the current route off the stack
              },
              child: Text("Back to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
