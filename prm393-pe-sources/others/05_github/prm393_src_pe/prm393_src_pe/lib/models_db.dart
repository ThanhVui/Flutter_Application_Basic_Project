import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String createdAt;

  User({this.id, required this.username, required this.email, required this.password, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      createdAt: map['createdAt'],
    );
  }
}

class Artwork {
  final int? id;
  final String title;
  final String artist;
  final int year;
  final String category;
  final String description;
  final int createdBy;

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
      title: map['title'],
      artist: map['artist'],
      year: map['year'],
      category: map['category'],
      description: map['description'],
      createdBy: map['createdBy'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'art_gallery.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            email TEXT,
            password TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE artworks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            artist TEXT,
            year INTEGER,
            category TEXT,
            description TEXT,
            createdBy INTEGER,
            FOREIGN KEY (createdBy) REFERENCES users (id)
          )
        ''');
      },
    );
  }

  // User CRUD
  Future<int> registerUser(User user) async {
    final db = await database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      return -1; // -1 if username is not unique
    }
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Artwork CRUD
  Future<int> insertArtwork(Artwork artwork) async {
    final db = await database;
    return await db.insert('artworks', artwork.toMap());
  }

  Future<List<Artwork>> getArtworks(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'artworks',
      where: 'createdBy = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Artwork.fromMap(maps[i]));
  }

  Future<int> deleteArtwork(int id) async {
    final db = await database;
    return await db.delete('artworks', where: 'id = ?', whereArgs: [id]);
  }
}
