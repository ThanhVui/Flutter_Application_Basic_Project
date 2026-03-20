import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/json_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  final TextEditingController controller = TextEditingController();

  void addTodo() {
    setState(() {
      todos.add(Todo(title: controller.text));
    });
    controller.clear();
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Backup App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter task',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  onTap: () => toggleTodo(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}