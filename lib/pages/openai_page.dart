import 'package:flutter/material.dart';

// OpenAI Page
class OpenAIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OpenAI Conversation Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("OpenAI Conversation Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
