import 'package:bible_app/pages/auth_layout.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // import the LoginPage

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Page Navigation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthLayout(),
    );
  }
}
