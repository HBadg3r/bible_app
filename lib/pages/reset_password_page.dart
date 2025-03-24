import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

// Page that allows a user to reset their password via email
class ResetPasswordPage extends StatefulWidget {
  final String? email; // Optional pre-filled email from previous screen

  const ResetPasswordPage({super.key, this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController controllerEmail = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Pre-fill email if provided through widget parameter
    if (widget.email != null) {
      controllerEmail.text = widget.email!;
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose(); // Clean up the controller
    super.dispose();
  }

  // Function to trigger the password reset email via AuthService
  void resetPassword() async {
    try {
      await AuthService().resetPassword(email: controllerEmail.text.trim());

      // Show confirmation snackbar
      showSnackBar();

      // Clear any previous error
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      // Show Firebase error message in the UI
      setState(() {
        errorMessage = e.message ?? 'Something went wrong';
      });
    }
  }

  // Show confirmation snackbar after reset email is sent
  void showSnackBar() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: const Text(
          'Please check your email to reset your password.',
          style: TextStyle(color: Colors.white),
        ),
        showCloseIcon: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Reset icon
            const Icon(Icons.lock_reset, size: 60, color: Colors.amber),
            const SizedBox(height: 32),

            // Email input field
            TextFormField(
              controller: controllerEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 10),

            // Display error message if any
            if (errorMessage.isNotEmpty) ...[
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 10),
            ],

            // Reset password button
            ElevatedButton(
              onPressed: resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Reset password'),
            ),
          ],
        ),
      ),
    );
  }
}
