import 'package:flutter/material.dart';

// Reflection Entry Page
class ReflectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reflection Entry Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Reflection Entry Page"),
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
