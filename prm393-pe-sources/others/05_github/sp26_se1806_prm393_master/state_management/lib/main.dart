import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/ui/cart_screen.dart';
import 'package:state_management/ui/home_screen.dart';
import 'package:state_management/ui/login_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: LoginScreen(),
      routes: {'/home': (context) => HomeScreen(),
      '/cart_details': (context) => CartScreen()
      },
    );
  }
}
