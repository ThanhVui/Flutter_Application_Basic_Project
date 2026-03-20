import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

// Task 15 – User Profile (Edit Screen)
/// Dedicated screen for updating user profile information.
/// Restricted to Username and Email updates as per requirements.
class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _nameCtrl = TextEditingController(text: widget.user.username);
    _emailCtrl = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // Task 15 – Action: Save profile changes to SQLite
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      // Create an updated User object (keeping old password and ID)
      final updatedUser = User(
        id: widget.user.id,
        username: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: widget.user.password, // Password remains unchanged
        createdAt: widget.user.createdAt,
      );

      try {
        await authProvider.updateProfile(updatedUser);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
          Navigator.pop(context); // Return to Profile Screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Update your identity details below. Your password remains unchanged.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Username Field
              const Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: "Enter username",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? "Username cannot be empty" : null,
              ),
              const SizedBox(height: 24),

              // Email Field
              const Text("Email address", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Enter email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email cannot be empty";
                  if (!v.contains("@")) return "Invalid email format";
                  return null;
                },
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6E6E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
