class Artwork {
  int id;
  String title;
  String artist;
  int year;
  String category;
  String description;
  int createdBy;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.category,
    required this.description,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
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

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['title'],
      title: json['title'],
      artist: json['artist'],
      year: json['year'],
      category: json['category'],
      description: json['description'],
      createdBy: json['createdBy'],
    );
  }
}