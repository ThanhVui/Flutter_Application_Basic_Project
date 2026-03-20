import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 10),
            Text(
              'Nguyễn Văn A',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Flutter Beginner'),
          ],
        ),
      ),
    );
  }
}
