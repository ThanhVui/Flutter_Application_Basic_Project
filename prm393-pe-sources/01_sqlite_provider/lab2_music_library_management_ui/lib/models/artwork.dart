/// Model class representing
class Artwork {
  int? id;
  String title;
  String artist;
  String year;
  String category;
  String description;
  int createdBy;

  /// Constructor for creating a new object.
  Artwork({
    this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.category,
    required this.description,
    required this.createdBy,
  });

  /// Converts an object into a Map structure.
  /// This is used when inserting or updating data in the SQLite database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'year': year,
      'category': category,
      'description': description,
      'createdBy': createdBy,
    };
  }

  /// Factory constructor to create an object from a database Map.
  /// Converts raw data fetched from SQLite into a structured Dart object.
  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      year: map['year'],
      category: map['category'],
      description: map['description'],
      createdBy: map['createdBy'],
    );
  }
}
