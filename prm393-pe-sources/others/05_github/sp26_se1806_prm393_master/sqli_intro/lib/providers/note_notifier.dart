import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqli_intro/db/database_helper.dart';
import '../models/note.dart';

part 'note_notifier.g.dart';

@riverpod
class NoteNotifier extends _$NoteNotifier {

  // build() - Return type (kiểu dữ liệu trả về của fn build())
  // sẽ xác định data của provider này
  // Data của provider -> ref.watch(provider)
  @override
  Future<List<Note>> build() async {
    return DatabaseHelper.instance.getList();
    //                   ^
    //                 Singleton
  }

  // delete note
  Future<void> deleteNote(int id) async {
    DatabaseHelper.instance.delete(id);
    ref.invalidateSelf(); // Báo cho biết build() cần chạy lại để cập nhật state
    await future;         // Chờ state mới được load xong
  }

  // create note
  Future<void> createNote(Note note) async {
    DatabaseHelper.instance.insert(note);
    ref.invalidateSelf(); // Báo cho biết build() cần chạy lại để cập nhật state
    await future;         // Chờ state mới được load xong
  }
}
