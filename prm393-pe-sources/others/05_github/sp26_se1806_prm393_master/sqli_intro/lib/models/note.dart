class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content,});

  /* 1. Chuyển từ object -> json -> string
  * JSON -> string -> lưu trữ trong local storage
  * [{
  *   id: 1,
  *   title: 'First note',
  *   content 'Content of the first note'
  * },
  * {
  *   id: 2,
  *   title: 'Note 2',
  *   content 'Content of the 2nd note'
  * }]
  *
  * 2. Từ local storage -> string -> json (map) -> object (Note)
  *  */


  // 1. Chuyển từ object (this) -> json (map) -> thư viện convert map -> string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content
    };
  }

  // 2. Từ local storage -> string thư viện convert -> json (map) -> object (Note)
  factory Note.fromJson(Map<String, dynamic> json) { // named constructor
    return Note(
        id: json['id'],
        title: json['title'],
        content: json['content']
    );
  }

}