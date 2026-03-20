import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  void register() async {
    // Check validation first
    if (!_formKey.currentState!.validate()) return;

    User user = User(
      username: usernameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      createdAt: DateTime.now().toString(),
    );

    final authProvider = context.read<AuthProvider>();
    String? error = await authProvider.register(user);

    if (error == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful! Please login."), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: $error"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameCtrl, 
                decoration: const InputDecoration(labelText: "Username *", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Please enter username" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailCtrl, 
                decoration: const InputDecoration(labelText: "Email *", border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Please enter email";
                  if (!v.contains("@")) return "Invalid email format";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordCtrl, 
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Password *", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.length < 3) ? "Password must be at least 3 characters" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmCtrl, 
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Confirm Password *", border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Please confirm password";
                  if (v != passwordCtrl.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: register, 
                  child: const Text("CREATE ACCOUNT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}