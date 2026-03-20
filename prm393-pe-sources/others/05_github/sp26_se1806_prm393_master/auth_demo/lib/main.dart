import 'package:auth_demo/providers/providers.dart';
import 'package:auth_demo/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Binding - Bảo đảm app phải được bind (LocalStorage)
  WidgetsFlutterBinding.ensureInitialized();
  // Lấy instance của LocalStorage ~ connection db
  final sharedPreferences = await SharedPreferences.getInstance();
  // Overrider lại giá trị cho sharedPreferencesProvider
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  ); // riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
