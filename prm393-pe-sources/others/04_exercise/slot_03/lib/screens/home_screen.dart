import 'package:flutter/material.dart';
import '../widgets/tasks_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BƯỚC 6: Khai báo danh sách ngay tại đây
  List<String> tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Daily Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: tasks.map((task) => TaskItem(title: task)).toList()),
      ),
      // BƯỚC 8: Thêm nút bấm
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Thêm một task mới vào danh sách mỗi khi bấm nút
            tasks.add('Công việc số ${tasks.length + 1}');
          });
        },
        tooltip: 'Thêm công việc',
        child: const Icon(Icons.add),
      ),
    );
  }
}
