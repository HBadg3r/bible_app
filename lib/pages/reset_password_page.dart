import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email; // optional pre-filled email

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
    if (widget.email != null) {
      controllerEmail.text = widget.email!;
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  void resetPassword() async {
    try {
      await AuthService().resetPassword(email: controllerEmail.text.trim());
      showSnackBar();
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Something went wrong';
      });
    }
  }

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
            const Icon(Icons.lock_reset, size: 60, color: Colors.amber),
            const SizedBox(height: 32),
            TextFormField(
              controller: controllerEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty) ...[
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 10),
            ],
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
