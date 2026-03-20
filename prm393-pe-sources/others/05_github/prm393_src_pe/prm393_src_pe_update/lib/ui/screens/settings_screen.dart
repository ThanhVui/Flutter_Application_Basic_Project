import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Appearance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch app theme to dark"),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: themeMode == ThemeMode.dark,
            onChanged: (v) {
              ref.read(themeProvider.notifier).toggleTheme(v);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {
              showAboutDialog(context: context, applicationName: "Product Manager App", applicationVersion: "1.2.0");
            },
          ),
        ],
      ),
    );
  }
}
