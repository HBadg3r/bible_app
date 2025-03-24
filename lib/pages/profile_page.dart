import 'package:bible_app/pages/change_password_page.dart';
import 'package:bible_app/pages/delete_account_page.dart';
import 'package:bible_app/pages/home_page.dart';
import 'package:bible_app/pages/login_page.dart';
import 'package:bible_app/pages/reset_password_page.dart';
import 'package:bible_app/pages/update_username_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

// Stateless widget that displays user profile info and account settings
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Logs out the user and navigates back to login screen
    void logout(BuildContext context) async {
      try {
        await AuthService().signOut();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // removes all previous routes
        );
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Avatar and user info (name + email)
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.displayName ?? "User",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    user?.email ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Settings section header
            const Text(
              "Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // Navigate to Update Username Page
            ListTile(
              title: const Text("Update username"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateUsernamePage(),
                  ),
                );
              },
            ),

            // Navigate to Change Password Page
            ListTile(
              title: const Text("Change password"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
            ),

            // Navigate to Delete Account Page
            ListTile(
              title: const Text("Delete my account"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountPage(),
                  ),
                );
              },
            ),

            // Push logout/home buttons to bottom
            const Spacer(),

            // Row with Logout and Go to Home Page buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => logout(context),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: const Text("Go to Home Page"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
