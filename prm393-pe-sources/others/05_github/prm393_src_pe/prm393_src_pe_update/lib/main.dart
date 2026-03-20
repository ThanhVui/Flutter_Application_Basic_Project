import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/providers.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';
import 'ui/screens/home_shell_screen.dart';
import 'ui/screens/add_edit_product_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ProductManagerApp(),
    ),
  );
}

class ProductManagerApp extends ConsumerWidget {
  const ProductManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.user == null) {
        ref.read(authStateProvider.notifier).checkSession();
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Manager App',
      // Dynamic Theme
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(elevation: 2, centerTitle: true),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        fontFamily: 'Inter',
      ),
      home: authState.isLoading 
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : authState.user != null 
          ? const HomeShellScreen() 
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeShellScreen(),
        '/addProduct': (context) => AddEditProductScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
