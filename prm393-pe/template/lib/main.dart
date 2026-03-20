// Import package material and provider
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// Import screens and providers
// import 'providers/auth_provider.dart';
// import 'providers/artwork_provider.dart';
// import 'providers/favorite_provider.dart';
// import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

// Import hive
// import 'package:hive_flutter/hive_flutter.dart'; // <--- Task 3 (Hive): Uncomment to use Hive

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter(); // <--- Task 3 (Hive): Uncomment to initialize Hive
  // ==================== Run App with MultiProvider =============================
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       // ChangeNotifierProvider(create: (_) => AuthProvider()),
  //       // ChangeNotifierProvider(create: (_) => ArtworkProvider()),
  //       // ChangeNotifierProvider(create: (_) => FavoriteProvider()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );

  // ==================== Run App without MultiProvider =============================
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Task 3 – Session Management: Check login session and initialize AuthProvider state before starting
  // ==================== Check Auth and Navigation to home or login ==================================
  // Future<Widget> _getStartScreen(BuildContext context) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);

  //   // Crucial: Load the stored session into the AuthProvider's memory
  //   await authProvider.checkSession();

  //   if (authProvider.isLoggedIn) {
  //     return const HomeScreen();
  //   } else {
  //     return const LoginScreen();
  //   }
  // }

  // ==================== Init Screen =================================================================
  Future<Widget> _getStartScreen(BuildContext context) async {
    return const HomeScreen();
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
