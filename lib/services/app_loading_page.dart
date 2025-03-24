import 'package:flutter/material.dart';

// A simple loading screen with an adaptive circular progress indicator
class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Center the loading spinner in the middle of the screen
      body: Center(
        child:
            CircularProgressIndicator.adaptive(), // Platform-specific spinner
      ),
    );
  }
}
