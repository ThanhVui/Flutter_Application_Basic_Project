/// Model class representing
class Favorite {
  int? id;
  int userId;
  int artworkId;
  String createdAt;

  /// Constructor for creating a new object.
  Favorite({
    this.id,
    required this.userId,
    required this.artworkId,
    required this.createdAt,
  });

  /// Converts an object into a Map structure.
  /// This is used when inserting or updating data in the SQLite database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'artworkId': artworkId,
      'createdAt': createdAt,
    };
  }

  /// Factory constructor to create an object from a database Map.
  /// Converts raw data fetched from SQLite into a structured Dart object.
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      userId: map['userId'],
      artworkId: map['artworkId'],
      createdAt: map['createdAt'],
    );
  }
}
