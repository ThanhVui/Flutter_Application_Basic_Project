import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DBHelper {
  // ==============================DATABASE CONNECTION SQLITE====================================================
  static Database? _db;

  // Get connection
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // Initialize Database
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'gallery.db');

    await deleteDatabase(
      path,
    ); // Delete database after initialize and delete all old data

    // LOG PATH
    print("DB PATH: $path");

    // CHECK DB EXISTS
    bool exists = await databaseExists(path);
    print("DB exists: $exists");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("onCreate CALLED => creating tables + inserting mock data");
        await createTables(db);
        await loadMockData(db);
      },
    );
  }

  // ==============================CREATE TABLES METHOD====================================================================
  Future<void> createTables(Database db) async {
    // USER
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      email TEXT,
      password TEXT,
      createdAt TEXT
    )
    ''');

    // ARTWORK
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

    // FAVORITE
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
  // =====================================================================================================================

  // ==============================READ FILE JSON DATA INTO DATABASE====================================================
  // Create Function to moooc data from json data
  Future<void> loadMockData(Database db) async {
    print("Loading mock data...");
    final data = json.decode(mooc_data);

    // USERS
    for (var user in data['users']) {
      await db.insert('users', user);
    }

    // ARTWORKS
    for (var art in data['artworks']) {
      await db.insert('artworks', art);
    }

    // FAVORITES
    for (var fav in data['favorites']) {
      await db.insert('favorites', fav);
    }

    print("Mock data inserted successfully");
  }

  // Data Sample To Load Into Database
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
  // =====================================================================================================================

  // ==============================READ FILE JSON INSERT INTO DATABASE====================================================
  // // Create Function to moooc data from json file // => Create file assets/data/mock_data.json before use this method
  // // import 'dart:convert';
  // // import 'package:flutter/services.dart';

  // UPDATE pubspec.yaml
  // flutter:
  //   assets:
  //     - assets/data/mock_data.json

  // Future<void> loadMockData(Database db) async {
  //   String jsonString = await rootBundle.loadString();
  //   final data = json.decode(jsonString);

  //   // USERS
  //   for (var user in data['users']) {
  //     await db.insert('users', user);
  //   }

  //   // ARTWORKS
  //   for (var art in data['artworks']) {
  //     await db.insert('artworks', art);
  //   }

  //   // FAVORITES
  //   for (var fav in data['favorites']) {
  //     await db.insert('favorites', fav);
  //   }
  // }
  // =====================================================================================================================
}

// =================================DATA TYPE IN SQLITE=====================================================================
// | Type        | Meaning                | Example       |
// | ----------- | ---------------------- | ------------- |
// | **NULL**    | No value               | `NULL`        |
// | **INTEGER** | Whole numbers          | `1, 100, -5`  |
// | **REAL**    | Floating-point numbers | `3.14, 2.5`   |
// | **TEXT**    | Strings                | `"hello"`     |
// | **BLOB**    | Binary data            | images, files |
// =====================================================================================================================
