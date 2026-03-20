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
      throw UnsupportedError('SQLite is not supported on Web. Please run on an Android or iOS emulator/device.');
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
      version: 1,

      // tăng 1 index để cập nhật db
      onCreate: (db, version) async {
        // Create products table (Master list)
        await db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, isFavorite INTEGER)',
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
            'id': 1,
            'title': 'Smartphone',
            'price': 699.99,
            'description': 'A high-end smartphone with a beautiful display.',
            'category': 'electronics',
            'image': '',
            'isFavorite': 0,
          },
          {
            'id': 2,
            'title': 'Casual Shirt',
            'price': 29.99,
            'description': 'Comfortable cotton shirt for everyday wear.',
            'category': "men's clothing",
            'image': '',
            'isFavorite': 1,
          },
          {
            'id': 3,
            'title': 'Silver Ring',
            'price': 150.00,
            'description': 'Elegant silver ring for special occasions.',
            'category': 'jewelery',
            'image': '',
            'isFavorite': 0,
          },
        ];

        for (var data in mockData) {
          batch.insert('products', data);
        }

        // Seed users
        batch.insert('users', {
          'username': 'admin',
          'password': 'password123',
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
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
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
