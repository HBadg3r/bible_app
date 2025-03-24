import 'package:bible_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Stateful widget for securely deleting the user's account
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers for user email and password input
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  // Message to display if an error occurs
  String errorMessage = '';

  // Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  // Call AuthService to reauthenticate and delete the user's account
  void deleteAccount() async {
    try {
      await authService.value.deleteAccount(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );

      // Navigate to the login screen after successful deletion
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      // If an error occurs, show it in the UI
      setState(() {
        errorMessage = 'Error deleting account: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete my account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Red "X" icon for emphasis
              const Icon(Icons.clear, size: 60, color: Colors.red),
              const SizedBox(height: 32),

              // Email input field
              TextFormField(
                controller: controllerEmail,
                decoration:
                    const InputDecoration(labelText: 'Enter your email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 16),

              // Password input field (obscured)
              TextFormField(
                controller: controllerPassword,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Current password'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password'
                    : null,
              ),
              const SizedBox(height: 20),

              // Display error message if present
              if (errorMessage.isNotEmpty) ...[
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 10),
              ],

              // Delete account button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    deleteAccount();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Delete Permanently"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
