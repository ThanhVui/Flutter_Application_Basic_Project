class Task {
  int id;
  String content;
  bool status;

  Task({
    required this.id,
    required this.content,
    required this.status,
  });

  void toggle() {
    status = !status;
  }
}
