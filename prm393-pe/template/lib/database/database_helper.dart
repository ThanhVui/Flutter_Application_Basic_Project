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
    String path = join(await getDatabasesPath(), 'gallery.db');

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

  // ============================== TABLE CREATION LOGIC (Task 6 – Database Relationships) ==============================
  
  /// Creates the necessary tables: users, artworks, and favorites.
  Future<void> createTables(Database db) async {
    // 1. Create 'users' table to store account credentials
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      email TEXT,
      password TEXT,
      createdAt TEXT
    )
    ''');

    // 2. Create 'artworks' table with a foreign key reference to the 'users' table
    await db.execute('''
    CREATE TABLE artworks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      artist TEXT,
      year TEXT,
      category TEXT,
      description TEXT,
      createdBy INTEGER,
      FOREIGN KEY (createdBy) REFERENCES users (id) ON DELETE CASCADE
    )
    ''');

    // Task 6: One user can favorite multiple artworks (User -> FavoriteArtwork Relationship)
    // 3. Create 'favorites' table to link users with their favorite artworks (Many-to-Many Relationship)
    await db.execute('''
    CREATE TABLE favorites(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      artworkId INTEGER,
      createdAt TEXT,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
      FOREIGN KEY (artworkId) REFERENCES artworks (id) ON DELETE CASCADE
    )
    ''');
  }

  // ============================== DATA SEEDING (MOCK DATA) ==============================

  /// Parses the internal JSON string and inserts initial data into the database.
  Future<void> loadMockData(Database db) async {
    print("Seeding database with mock data...");
    final data = json.decode(mooc_data);

    // Insert initial users
    for (var user in data['users']) {
      await db.insert('users', user);
    }

    // Insert initial artworks
    for (var art in data['artworks']) {
      await db.insert('artworks', art);
    }

    // Insert initial favorites
    for (var fav in data['favorites']) {
      await db.insert('favorites', fav);
    }

    print("Database seeding completed successfully.");
  }

  /// Initial sample data in JSON format
  String mooc_data = '''
  {
    "users": [
      {
        "username": "admin",
        "email": "admin@gmail.com",
        "password": "123456",
        "createdAt": "2024-01-01"
      }
    ],
    "artworks": [
      {
        "title": "Sunset Landscape",
        "artist": "John Doe",
        "year": "2020",
        "category": "Landscape",
        "description": "Beautiful sunset view",
        "createdBy": 1
      },
      {
        "title": "Abstract Dream",
        "artist": "Anna Smith",
        "year": "2022",
        "category": "Abstract",
        "description": "Colorful abstract painting",
        "createdBy": 1
      },
      {
        "title": "Portrait Lady",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      },
      {
        "title": "Thanh",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      },
      {
        "title": "Vui",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      }
    ],
    "favorites": [
      {
        "userId": 1,
        "artworkId": 1,
        "createdAt": "2024-01-02"
      }
    ]
  }''';
}