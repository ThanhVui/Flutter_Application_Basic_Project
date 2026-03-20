import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static Database? _database;

  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // --- Session Management (SharedPreferences) ---
  Future<void> saveToken(String token, String email, {String? fullName, String? phone}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("email", email);
    await prefs.setString("fullName", fullName ?? "User");
    await prefs.setString("phone", phone ?? "");
  }

  Future<User?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    return User(
      email: prefs.getString("email") ?? "",
      token: token,
      fullName: prefs.getString("fullName") ?? "",
      phone: prefs.getString("phone") ?? "",
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- SQLite (Database) ---
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product_manager_v2.db');
    return await openDatabase(
      path,
      version: 2, // Upgraded version for new table support or changes
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
         // Simple re-creation for this exercise
         await db.execute("DROP TABLE IF EXISTS users");
         await db.execute("DROP TABLE IF EXISTS products");
         await db.execute("DROP TABLE IF EXISTS orders");
         await db.execute("DROP TABLE IF EXISTS order_items");
         await _createTables(db);
      }
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        fullName TEXT,
        phone TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY,
        date TEXT,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER,
        productId INTEGER,
        quantity INTEGER,
        FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- User Ops (SQLite) ---
  Future<int> registerUser(String email, String password, String fullName, String phone) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
      });
    } catch (e) {
      return -1; // Fail if not unique email
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  // --- Product Ops ---
  Future<void> saveProducts(List<Product> products) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('products');
      for (var p in products) {
        await txn.insert('products', p.toJson());
      }
    });
  }

  Future<List<Product>> getLocalProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> createOrder(Order order, List<Map<String, dynamic>> items) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('orders', order.toMap());
      for (var item in items) {
        await txn.insert('order_items', {
          'orderId': order.id,
          'productId': item['productId'],
          'quantity': item['quantity'],
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getOrderFullData(int orderId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT p.*, oi.quantity FROM products p
      INNER JOIN order_items oi ON p.id = oi.productId
      WHERE oi.orderId = ?
    ''', [orderId]);
  }
}
