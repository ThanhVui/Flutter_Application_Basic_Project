import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

/// Screen to handle new user registration.
/// Collects Username, Email, and Password, validates them, and stores in SQLite.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // GlobalKey for validating the form state
  final _formKey = GlobalKey<FormState>();
  
  // Text input controllers for registration details
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  /// Logic to execute when the 'Register' button is pressed.
  void register() async {
    // 1. Validate all form fields (Check for empty, email format, and password match)
    if (!_formKey.currentState!.validate()) return;

    // 2. Wrap input data into a User object
    User user = User(
      username: usernameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      createdAt: DateTime.now().toString(),
    );

    final authProvider = context.read<AuthProvider>();
    
    // 3. Attempt to save the new user to the database via AuthProvider
    String? error = await authProvider.register(user);

    // 4. Handle registration result
    if (error == null) {
      if (mounted) {
        // Success: Show confirmation and return to login screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful! Please login."), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        // Failure: Show error message (e.g., Username already exists)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: $error"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light blue-grey background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Registration Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Section
                      const Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Start managing artworks with your own gallery space.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Username Field
                      _buildTextField(
                        controller: usernameCtrl,
                        label: "Username",
                        icon: Icons.person_outline,
                        hint: "testuser123",
                        validator: (v) => (v == null || v.isEmpty) ? "Please enter username" : null,
                      ),
                      const SizedBox(height: 20),
                      
                      // Email Field with format validation
                      _buildTextField(
                        controller: emailCtrl,
                        label: "Email",
                        icon: Icons.alternate_email,
                        hint: "test@example.com",
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Please enter email";
                          if (!v.contains("@")) return "Invalid email format";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Password Field with length validation
                      _buildTextField(
                        controller: passwordCtrl,
                        label: "Password",
                        icon: Icons.lock_outline,
                        hint: "••••••••••••",
                        obscureText: true,
                        validator: (v) => (v == null || v.length < 3) ? "Password too short" : null,
                      ),
                      const SizedBox(height: 20),
                      
                      // Confirm Password Field with match validation
                      _buildTextField(
                        controller: confirmCtrl,
                        label: "Confirm Password",
                        icon: Icons.verified_user_outlined,
                        hint: "••••••••••••",
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Please confirm password";
                          if (v != passwordCtrl.text) return "Passwords do not match";
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Register Primary Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B), // Dark Teal Primary
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Helper Button to return to Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Sign In",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Utility widget to build styled text input fields consistently.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      validator: validator,
    );
  }
}