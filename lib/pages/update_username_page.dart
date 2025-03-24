import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
  final TextEditingController controllerUsername = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    controllerUsername.dispose();
    super.dispose();
  }

  void updateUsername() async {
    try {
      await AuthService().updateUsername(
        username: controllerUsername.text.trim(),
      );
      showSnackBarSuccess();
    } catch (e) {
      showSnackBarFailure();
    }
  }

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
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.edit, size: 60, color: Colors.amber),
              const SizedBox(height: 32),
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
