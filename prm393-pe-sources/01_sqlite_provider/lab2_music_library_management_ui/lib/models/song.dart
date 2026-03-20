/// Model class representing
class Song {
  int? id;
  String title;
  String artist;
  String year;
  String genre;
  int isFavorite;

  /// Constructor for creating a new object.
  Song({
    this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.genre,
    required this.isFavorite,
  });

  /// Converts an object into a Map structure.
  /// This is used when inserting or updating data in the SQLite database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'year': year,
      'genre': genre,
      'isFavorite': isFavorite,
    };
  }

  /// Factory constructor to create an object from a database Map.
  /// Converts raw data fetched from SQLite into a structured Dart object.
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      year: map['year'],
      genre: map['genre'],
      isFavorite: map['isFavorite'],
    );
  }
}
