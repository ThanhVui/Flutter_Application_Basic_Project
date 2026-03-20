import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  int userId;
  
  @HiveField(2)
  int artworkId;
  
  @HiveField(3)
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
      userId: map['userId'] ?? 0,
      artworkId: map['artworkId'] ?? 0,
      createdAt: map['createdAt'] ?? '',
    );
  }
}
