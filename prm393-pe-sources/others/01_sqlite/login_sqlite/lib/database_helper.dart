import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('login.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      // nào mún thêm cột mở lên
      onUpgrade: _upgradeDB,
    );
  }
  // INSERT INTO products (name, price, description)
  // VALUES ('Sản phẩm test', 100000, 'Đây là sản phẩm thêm trực tiếp');
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.insert('users', {
      'username': 'admin',
      'password': '123456',
    });

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT
      )
    ''');

    await db.insert('products', {
      'name': 'Sản phẩm mẫu 1',
      'price': 100000,
      'description': 'Đây là sản phẩm mẫu',
    });
  }

  // function cập nhật data
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT
      )
    ''');
      // thêm dữ liệu mẫu
      await db.insert('products', {
        'name': 'Sản phẩm mẫu 1',
        'price': 100000,
        'description': 'Đây là sản phẩm mẫu'
      });


    }
  }
  Future<int> checkLogin(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.length;
  }

  Future<int> register(String username, String password) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'username': username,
        'password': password,
      });
    } catch (e) {
      return -1;
    }
  }

  // Product CRUD
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('products', orderBy: 'id DESC');
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}