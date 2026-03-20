import 'package:hive/hive.dart';

part 'artwork.g.dart';

@HiveType(typeId: 1)
class Artwork extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String artist;
  
  @HiveField(3)
  String year;
  
  @HiveField(4)
  String category;
  
  @HiveField(5)
  String description;
  
  @HiveField(6)
  int createdBy;

  Artwork({
    this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.category,
    required this.description,
    required this.createdBy,
  });

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

  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'],
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      year: map['year'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? 0,
    );
  }
}
