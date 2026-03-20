import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqli_intro/providers/note_notifier.dart';

import '../models/note.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
          title: _titleController.text, content: _contentController.text);
      ref.read(noteProvider.notifier).createNote(newNote);
      // if (mounted) {
        Navigator.pop(context);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI:
    // Form
    // TextField: title
    // TextField: content
    // Button: submit

    return Scaffold(
      appBar: AppBar(title: Text("Add new note")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (v) => v!.isEmpty ? "this cannot be empty" : null,
                decoration: InputDecoration(
                  hintText: "Title",
                  labelText: "Title",
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              TextFormField(
                controller: _contentController,
                validator: (v) => v!.isEmpty ? "this cannot be empty" : null,
                decoration: InputDecoration(
                  hintText: "Content",
                  labelText: "Content",
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Save note"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
