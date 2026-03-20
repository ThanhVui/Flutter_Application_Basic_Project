class Favorite {
  int? id;
  int userId;
  int artworkId;
  String createdAt;

  Favorite({
    this.id,
    required this.userId,
    required this.artworkId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'artworkId': artworkId,
      'createdAt': createdAt,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      userId: map['userId'],
      artworkId: map['artworkId'],
      createdAt: map['createdAt'],
    );
  }
}