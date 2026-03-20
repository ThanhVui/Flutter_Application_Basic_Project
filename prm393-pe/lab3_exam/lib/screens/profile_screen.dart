import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'edit_profile_screen.dart';

// Task 15 – User Profile
/// Screen to display detailed information about the logged-in user.
/// Fetches the User model from the database using AuthProvider.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light background
      appBar: AppBar(
        title: const Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Task 15 – User Profile (Edit Action): Button to open the update form
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E293B)),
            onPressed: () async {
              final user = await authProvider.getUserProfile();
              if (user != null && context.mounted) {
                // Task 15 – Navigation: Moving the update logic from a Dialog to a dedicated Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                ).then((_) => (context as Element).markNeedsBuild()); // Ensure screen refreshes on return
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        // Task 15: Fetch full profile data from SQLite
        future: authProvider.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User profile not found."));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 1. Profile Avatar Section
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF0D6E6E),
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // 2. User Basic Info
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 40),

                // 3. Information Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(Icons.person_outline_rounded, "Username", user.username),
                      const Divider(height: 32),
                      _buildProfileItem(Icons.email_outlined, "Email Address", user.email),
                      const Divider(height: 32),
                      _buildProfileItem(Icons.calendar_month_outlined, "Member Since", 
                        user.createdAt.split(' ')[0]), // Show date only
                      const Divider(height: 32),
                      _buildProfileItem(Icons.fingerprint_rounded, "User ID", "#${user.id}"),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // 4. Logout Helper Shortcut
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton.icon(
                    onPressed: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text("Logout from Account", 
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper widget for profile list items
  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFA7F3D0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF065F46), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ],
        ),
      ],
    );
  }
}
