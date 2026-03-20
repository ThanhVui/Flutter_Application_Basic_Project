import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/song_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ), // Auth Provider (Login, Logout, Check Session)
        ChangeNotifierProvider(
          create: (_) => SongProvider(),
        ), // Song Provider (CRUD)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Check login session and initialize AuthProvider state before starting
  Future<Widget> _getStartScreen(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Crucial: Load the stored session into the AuthProvider's memory
    await authProvider.checkSession();

    // Check login session and initialize AuthProvider state before starting
    if (authProvider.isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        // Pass context to the helper function
        future: _getStartScreen(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
