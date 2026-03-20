class Product {
  final int id;
  String title;
  int year;
  String description;
  String category;
  int createdBy;
  String artist;

  Product({
    required this.id,
    required this.title,
    required this.year,
    required this.description,
    required this.category,
    required this.artist,
    required this.createdBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      year: json['year'],
      description: json['description'],
      category: json['category'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'year': year,
      'description': description,
      'category': category,
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  // For SQLite specifically
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      year: map['year'],
      description: map['description'],
      category: map['category'],
      createdBy: map['createdBy'],
    );
  }
}
