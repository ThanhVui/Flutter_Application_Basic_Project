import 'package:auth_demo/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final authService = ref.read(authServiceProvider);
                  print(_emailController.text);
                  print(_passwordController.text);
                  authService.login(_emailController.text, _passwordController.text);


                  // final value = AuthService().loginWithEmail(
                  //   _emailController.text.trim(),
                  //   _passwordController.text.trim(),
                  // );
                  // if (!context.mounted) return;
                  // if (value == "Login Successful") {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //         value,
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       backgroundColor: Colors.green.shade400,
                  //     ),
                  //   );
                  //   // Navigator.restorablePushAndRemoveUntil(context, "/", (route) => false);
                  // }
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
