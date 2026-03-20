import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqli_intro/ui/list_note_screen.dart';

//
void main() async {
  // Binding - Bảo đảm app phải được bind (LocalStorage) +
  // sqli cũng cần ensure binding
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  ); // riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: ListNoteScreen(),
      // routes: [],... // List / Add note screen
    );
  }
}