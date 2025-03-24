import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Page that allows the user to update their display name
class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
  // Controller for the username input field
  final TextEditingController controllerUsername = TextEditingController();

  // Key for validating the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variable to hold error messages (if needed)
  String errorMessage = '';

  @override
  void dispose() {
    controllerUsername.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  // Calls AuthService to update the username
  void updateUsername() async {
    try {
      await AuthService().updateUsername(
        username: controllerUsername.text.trim(),
      );
      showSnackBarSuccess(); // Show success message
    } catch (e) {
      showSnackBarFailure(); // Show error message
    }
  }

  // Success snackbar
  void showSnackBarSuccess() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Username changed successfully!',
          style: TextStyle(color: Colors.white),
        ),
        showCloseIcon: true,
      ),
    );
  }

  // Error snackbar
  void showSnackBarFailure() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Something went wrong. Please try again.',
          style: TextStyle(color: Colors.white),
        ),
        showCloseIcon: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update username')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Attach form key for validation
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Icon for context
              const Icon(Icons.edit, size: 60, color: Colors.amber),
              const SizedBox(height: 32),

              // Username input field
              TextFormField(
                controller: controllerUsername,
                decoration: const InputDecoration(labelText: 'New username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter something';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Update button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUsername();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Update username'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
