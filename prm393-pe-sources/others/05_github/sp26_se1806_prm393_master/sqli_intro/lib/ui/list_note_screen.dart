import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqli_intro/models/note.dart';
import 'package:sqli_intro/providers/note_notifier.dart';
import 'package:sqli_intro/ui/add_note_screen.dart';

class ListNoteScreen extends ConsumerStatefulWidget {
  const ListNoteScreen({super.key});

  @override
  ConsumerState<ListNoteScreen> createState() => _ListNoteScreenState();
}

class _ListNoteScreenState extends ConsumerState<ListNoteScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.watch(provider) -> AsyncValue<List<Note>>
    final notesAsyncValue = ref.watch(noteProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('SQLite Notes Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: // Những thao tác bất đồng bộ: DB, API call... thì có cơ chế loading -> data(ok)/error
        notesAsyncValue.when(
          // fn truền vào nhận 1 param (đang đặt tên biến là notes), kiểu là List<Note> (xem bên trên)
          data: (notes) => notes.isEmpty
              ? Text('There are no notes')
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: Row(
                        // Đối với Row, mainAxis -> chiều ngnag
                        // Như vậy, mainAxisSize -> width
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(noteProvider.notifier)
                                  .deleteNote(note.id!);
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              // Navigator.push...
                            },
                            icon: Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          error: (_, stack) => Text('There is an error while loading notes'),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ref
          //     .read(noteProvider.notifier)
          //     .createNote(Note(title: 'Test notes', content: 'Note content'));
          // Navigator chuyen qua screen -> dang ky route
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// CLASSWORK
// 1) Điều chỉnh lại: Thêm giao diện (Form) hỗ trợ thêm mới 1 note Add new note
//   - Field: Title, Content. (nếu dùng controller thì nhớ dispose)
//   - Button: Để submit form. Submit sẽ save note vào DB và quay về màn hình List
//   - Form: Validate Title ít nhất 3 ký tự, content ít nhất 10 ký tự.
// 2) Điều chỉnh sự kiện press của nút Floating để route qua màn hình Add new note
// 3) Thêm Edit btn cho ListTile (cạnh Delete btn)
//   - Route user về màn hình Edit note
//   - Logic (validation, flow...) Tương tự màn hình Add note.
//
