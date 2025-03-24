// Import necessary packages and files
import 'package:bible_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';
import '../services/app_loading_page.dart'; // Loading spinner page

// StatelessWidget that handles user authentication state
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to auth state changes from Firebase
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges, // Firebase auth state stream
      builder: (context, snapshot) {
        // While Firebase checks if the user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoadingPage(); // Show loading spinner
        }
        // If a user is logged in, show the ProfilePage
        else if (snapshot.hasData) {
          return const ProfilePage();
        }
        // If no user is logged in, show the LoginPage
        else {
          return LoginPage();
        }
      },
    );
  }
}
