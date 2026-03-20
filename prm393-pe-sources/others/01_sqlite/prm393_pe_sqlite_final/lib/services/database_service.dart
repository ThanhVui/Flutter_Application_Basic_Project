import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError(
        'SQLite is not supported on Web. Please run on an Android or iOS emulator/device.',
      );
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // SCENARIO 1: SELF-CREATED DATABASE (Current default)
    String path = join(await getDatabasesPath(), 'products_db.db');
    return await openDatabase(
      path,
      version: 2,

      // tăng 1 index để cập nhật db
      onCreate: (db, version) async {
        // Create products table (Master list)
        await db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, artist TEXT,year INTERGER, description TEXT, category TEXT,createdBy INTERGER)',
        );

        // Create users table
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT, email TEXT)',
        );

        // Seed mock data using Batch
        final batch = db.batch();

        // Seed products
        final mockData = [
          {
            "id": 1,
            "title": "Starry Night",
            "artist": "Vincent van Gogh",
            "year": 1889,
            "category": "Abstract",
            "description":
                "A famous Abstract of a swirling night sky over a small town.",
            "createdBy": 1,
          },
          {
            "id": 2,
            "title": "Mona Lisa",
            "artist": "Leonardo da Vinci",
            "year": 1503,
            "category": "Abstract",
            "description":
                "A portrait Abstract known for the subject's mysterious smile.",
            "createdBy": 1,
          },
          {
            "id": 3,
            "title": "The Persistence of Memory",
            "artist": "Salvador Dali",
            "year": 1931,
            "category": "Abstract",
            "description": "A surreal Abstract featuring melting clocks.",
            "createdBy": 1,
          },
          {
            "id": 4,
            "title": "The Thinker",
            "artist": "Auguste Rodin",
            "year": 1902,
            "category": "Realism",
            "description":
                "A bronze Realism representing philosophy and deep thought.",
            "createdBy": 1,
          },
          {
            "id": 5,
            "title": "The Scream",
            "artist": "Edvard Munch",
            "year": 1893,
            "category": "Abstract",
            "description":
                "An expressionist Abstract showing anxiety and fear.",
            "createdBy": 1,
          },
          {
            "id": 6,
            "title": "Girl with a Pearl Earring",
            "artist": "Johannes Vermeer",
            "year": 1665,
            "category": "Abstract",
            "description":
                "A famous portrait sometimes called the Dutch Mona Lisa.",
            "createdBy": 2,
          },
          {
            "id": 7,
            "title": "David",
            "artist": "Michelangelo",
            "year": 1504,
            "category": "Realism",
            "description":
                "A marble statue representing the biblical hero David.",
            "createdBy": 2,
          },
          {
            "id": 8,
            "title": "The Kiss",
            "artist": "Gustav Klimt",
            "year": 1908,
            "category": "Abstract",
            "description":
                "A symbolist Abstract representing love and intimacy.",
            "createdBy": 2,
          },
          {
            "id": 9,
            "title": "Campbell's Soup Cans",
            "artist": "Andy Warhol",
            "year": 1962,
            "category": "Landscape",
            "description":
                "A famous Landscape work representing consumer culture.",
            "createdBy": 2,
          },
          {
            "id": 10,
            "title": "Balloon Dog",
            "artist": "Jeff Koons",
            "year": 1994,
            "category": "Realism",
            "description": "A shiny Realism resembling a balloon animal.",
            "createdBy": 2,
          },
        ];

        for (var data in mockData) {
          batch.insert('products', data);
        }

        // Seed users
        batch.insert('users', {
          'username': 'artist01',
          'password': '123456',
          'email': 'admin@example.com',
        });

        await batch.commit(noResult: true);
      },
    );

    /*
    // SCENARIO 2: PRE-POPULATED DATABASE FROM ASSETS
    // 1. Uncomment this block and comment out the Scenario 1 block above.
    // 2. Add the .db file to your assets folder and update pubspec.yaml.
    
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "data.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Copy from asset
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "data.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    
    return await openDatabase(path, readOnly: false);
    */
  }

  // Product methods
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toJson());
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ? AND isFavorite = 1',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  // User methods
  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<bool> checkUsernameExists(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isNotEmpty;
  }

  Future<User?> getUser(String username, String password) async {
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
}
