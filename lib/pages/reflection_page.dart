import 'package:flutter/material.dart';

// Stateless widget that represents the Reflection Entry Page
class ReflectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with page title
      appBar: AppBar(title: Text("Reflection Entry Page")),

      // Centered content in the body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Label to indicate the current page
            Text("Reflection Entry Page"),

            // Button to navigate back to the previous page (usually Home Page)
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
