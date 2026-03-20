import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(title: Text('Home'), leading: Icon(Icons.home)),
          ListTile(title: Text('Category'), leading: Icon(Icons.category)),
          ListTile(title: Text('Login'), leading: Icon(Icons.person)),
        ],
      ),
    );
  }
}
