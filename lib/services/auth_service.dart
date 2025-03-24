import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Global ValueNotifier to easily access and react to AuthService updates
ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

// A class that encapsulates all Firebase Authentication logic
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Returns the currently signed-in user (nullable)
  User? get currentUser => firebaseAuth.currentUser;

  // Emits updates whenever the authentication state changes
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Signs in a user with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Creates a new user account with email and password
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Signs out the currently signed-in user
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Sends a password reset email to the provided email address
  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Updates the display name (username) of the current user
  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser!.updateDisplayName(username);
  }

  // Reauthenticates and deletes the current user's account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await currentUser!.reauthenticateWithCredential(
        credential); // Required for secure operations
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  // Reauthenticates and updates the user's password
  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
