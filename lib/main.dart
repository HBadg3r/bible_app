import 'package:bible_app/pages/auth_layout.dart';
import 'package:flutter/material.dart';
// Import LoginPage (used if not using AuthLayout directly)

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Auto-generated Firebase config file

// Entry point of the app
void main() async {
  // Ensures widgets and Firebase are initialized before runApp is called
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Launch the app
  runApp(MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Page Navigation', // Title of the app
      theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark), // Default theme

      // Starts with AuthLayout which determines whether to show Login or Home/Profile
      home: const AuthLayout(),
    );
  }
}
