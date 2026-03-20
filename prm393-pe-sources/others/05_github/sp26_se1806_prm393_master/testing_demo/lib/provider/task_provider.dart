import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testing_demo/model/task.dart';

part 'task_provider.g.dart';


@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  List<Task> build() {
    return <Task>[];
  }

  void createTask(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch,
      content: trimmed,
      status: false,
    );

    state = [...state, task];
  }

  Task? getById(int id) {
    for (final task in state) {
      if (task.id == id) return task;
    }
    return null;
  }

  void updateTask(int id, String newContent) {
    final trimmed = newContent.trim();
    if (trimmed.isEmpty) return;

    state = [
      for (final task in state)
        if (task.id == id)
          Task(
            id: task.id,
            content: trimmed,
            status: task.status,
          )
        else
          task,
    ];
  }

  void deleteTask(int id) {
    state = state.where((task) => task.id != id).toList();
  }

  void toggleTaskStatus(int id, bool status) {
    state = [
      for (final task in state)
        if (task.id == id)
          if (task.status == status) ...[
            task,
          ] else ...[
            task..toggle(),
          ]
        else
          task,
    ];
  }
}
