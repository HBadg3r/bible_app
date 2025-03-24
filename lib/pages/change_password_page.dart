import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Stateful widget for changing user password
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Text controllers for capturing user input
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerCurrentPassword =
      TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();

  // Dispose controllers to free memory when widget is removed
  @override
  void dispose() {
    controllerEmail.dispose();
    controllerCurrentPassword.dispose();
    controllerNewPassword.dispose();
    super.dispose();
  }

  // Call AuthService to update the user's password after reauthenticating
  void updatePassword() async {
    try {
      await AuthService().resetPasswordFromCurrentPassword(
        currentPassword: controllerCurrentPassword.text.trim(),
        newPassword: controllerNewPassword.text.trim(),
        email: controllerEmail.text.trim(),
      );
      showSnackBarSuccess(); // Show success message
    } catch (e) {
      showSnackBarFailure(); // Show error message
    }
  }

  // Success snackbar UI
  void showSnackBarSuccess() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: const Text(
          "Password changed successfully!",
          style: TextStyle(color: Colors.white),
        ),
        showCloseIcon: true,
      ),
    );
  }

  // Failure snackbar UI
  void showSnackBarFailure() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        content: const Text(
          "Failed to change password. Please try again.",
          style: TextStyle(color: Colors.white),
        ),
        showCloseIcon: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Lock icon for visual context
            const Icon(Icons.lock, size: 60, color: Colors.amber),
            const SizedBox(height: 32),

            // Email input field
            TextField(
              controller: controllerEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),

            // Current password field
            TextField(
              controller: controllerCurrentPassword,
              decoration: const InputDecoration(labelText: 'Current password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // New password field
            TextField(
              controller: controllerNewPassword,
              decoration: const InputDecoration(labelText: 'New password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Button to trigger password update
            ElevatedButton(
              onPressed: updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Change password'),
            ),
          ],
        ),
      ),
    );
  }
}
