import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Native key

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() async {
    // Native Validation
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    String? error = await authProvider.login(
      usernameCtrl.text.trim(),
      passwordCtrl.text,
    );

    if (error == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey, // Assign Key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.palette_outlined, size: 100, color: Colors.blue),
              const SizedBox(height: 40),
              TextFormField(
                controller: usernameCtrl,
                decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Username is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Password is required" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: login, 
                  child: const Text("LOGIN"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text("No account? Register now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
