import 'dart:convert';
import 'package:local_storage/models/note.dart';
import 'package:local_storage/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_notifier.g.dart';

@riverpod
class NoteNotifier extends _$NoteNotifier {
  // Key trong LS
  static const String _keyName = 'notes';
  // Khởi tạo state ban đầu là 1 ds rỗng
  List<Note> build() {
    _loadNotes();
    return [];
  }
  // P/thức để lấy ds note trong LS
  // 1) Kết nối LocalStorage (thông qua sharedPreferenceProvider)
  // 2) Get StringList theo Key
  // 3) cập nhật state
  void _loadNotes() {
    final prefs = ref.read(sharedPreferencesProvider); // 1
    final notesJson = prefs.getStringList(_keyName) ?? []; // 2
    state = notesJson.map((str) => Note.fromJson(json.decode(str))).toList();
  }

  // CRUD
  Future<void> addNote(Note newNote) async {
    // Add thêm note mới
    state = [...state, newNote];
    // Save
    await _save();
  }

  // 1) Lấy kết nối
  // 2) Set 2.1 state hiện tại (mảng) ---> json -> string -> 2.2 save
  Future<void> _save() async {
    final prefs = ref.read(sharedPreferencesProvider); //prefs.set // 1
    final notesJson = state.map((note) => json.encode(note.toJson())).toList(); // 2.1
    await prefs.setStringList(_keyName, notesJson); // 2.2
  }

}