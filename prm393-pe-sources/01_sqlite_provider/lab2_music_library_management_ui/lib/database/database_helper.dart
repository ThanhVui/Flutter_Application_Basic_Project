import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

/// Database Helper class to manage SQLite operations using the singleton pattern.
class DBHelper {
  // ============================== DATABASE CONNECTION CONFIGURATION ==============================
  static Database? _db;

  /// Getter for the database instance.
  /// If the database is already open, it returns the existing instance.
  /// Otherwise, it initializes the database connection.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  /// Initializes the database by defining its path and opening it.
  Future<Database> initDB() async {
    // Determine the path to the database file (gallery.db)
    String path = join(await getDatabasesPath(), 'songs.db');

    // WARNING: Deletes the existing database to ensure a fresh start with mock data during development.
    await deleteDatabase(path);

    // Logging for debugging purposes
    print("DB PATH: $path");

    // Open the database and handle table creation
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("onCreate: Creating tables and inserting mock data...");
        await createTables(db);
        await loadMockData(db);
      },
    );
  }

  // ============================== TABLE CREATION LOGIC ==============================
  /// Creates the necessary tables: users, artworks, and favorites.
  Future<void> createTables(Database db) async {
    // 1. Create 'songs' table to store account credentials
    await db.execute('''
    CREATE TABLE songs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      artist TEXT,
      year TEXT,
      genre TEXT,
      isFavorite INTEGER
    )
    ''');
  }

  // ============================== DATA SEEDING (MOCK DATA) ==============================
  /// Parses the internal JSON string and inserts initial data into the database.
  Future<void> loadMockData(Database db) async {
    print("Seeding database with mock data...");
    final data = json.decode(mooc_data);

    // Insert initial users
    for (var song in data['songs']) {
      await db.insert('songs', song);
    }

    print("Database seeding completed successfully.");
  }

  /// Initial sample data in JSON format
  String mooc_data = '''
  {
    "songs": 
    [
      {
        "title": "Sunset Landscape",
        "artist": "John Doe",
        "year": "2020",
        "genre": "Pop",
        "isFavorite": 1
      },
      {
        "title": "Abstract Dream",
        "artist": "Anna Smith",
        "year": "2022",
        "genre": "Rock",
        "isFavorite": 0
      },
      {
        "title": "Portrait Lady",
        "artist": "Leonardo",
        "year": "2019",
        "genre": "Jazz",
        "isFavorite": 1
      }
    ]
  }''';
}
