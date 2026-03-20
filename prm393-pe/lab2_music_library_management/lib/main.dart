import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/song_provider.dart';
import 'providers/favorite_provider.dart';
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
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ), // Favorite Provider (Favorites)
      ],
      child: const MyApp(),
    ),
  );
}

// Task 2: Session Management - Check login session before starting the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Check login session and initialize AuthProvider state before starting
  Future<Widget> _getStartScreen(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Task 2: Session Management - Load stored session from local storage (SharedPreferences)
    await authProvider.checkSession();

    // Check login session and determine initial screen
    if (authProvider.isLoggedIn) {
      return const HomeScreen(); // Task 2: Navigate to Home if logged in
    } else {
      return const LoginScreen(); // Task 2: Navigate to Login if not
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
