import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqli_intro/models/note.dart';

class DatabaseHelper {
  // Thuoc tinh lien quan den DB sqli
  // Ten file sqlite
  static const _databaseName = 'se1806_notemanagement.db';
  static const _databaseVersion = 1;
  static const _noteTableName = 'notes';

  // Singleton pattern
  // (bảo đảm chỉ tồn tại duy nhất 1 instance (đối tượng) database helper trong hệ thống)
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // doi tuong database
  static Database? _database;

  // getter (tra ve doi tuong database trong object db helper)
  // Neu ton tai object db thi return, con ko thi init
  Future<Database> get database async {
    _database ??= await _initDatabases();
    return _database!;
  }

  // init databse
  // 1. xac dinh path
  // 2. Tao ket noi
  // 3. Khi init thuc thi 1 so viec (tao bang...)
  // 4. Return Database
  Future<Database> _initDatabases() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    // Debug: in path
    print('DB Path: $path');
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // fn de init db (tao bang)
  Future<void> _onCreate(Database db, int version) async {
    // Cau lenh tao bang
    // Autoincrement ~ SQL Server identity cơ chế tự tăng
    await db.execute('''
      CREATE TABLE $_noteTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  }

  // CRUD
  // ------ LIST ------
  Future<List<Note>> getList() async {
    final db = await database;
    List<Map<String, Object?>> maps = await db.query(
      _noteTableName,
      orderBy: 'id DESC',
    );

    // Raw result set cua lenh db.query tra ve List cua Map
    // [
    //   { 'col1': 'val', 'col2': 'val' .... },
    //   { 'col1': 'val', 'col2': 'val' .... },
    // ]

    return [for (final map in maps) Note.fromJson(map)];
  }

  // --------- CREATE -----------
  Future<int> insert(Note note) async {
    final db = await database;
    return db.insert(
      _noteTableName,
      note.toJson(),
      // conflictAlgorithm: ConflictAlgorithm.replace, // replace = nếu trùng id thì thay thế
      // conflictAlgorithm: ConflictAlgorithm.ignore, // ignore = nếu trùng id thì bỏ qua
    );
  }

  // --------- GET BY ID  -----------
  // --------- DELETE -----------
  Future<int> delete(int id) async {
    final db = await database;
    // Sử dụng đúng convention để tránh các lỗi security (SQL injection...)
    return db.delete(_noteTableName, where: 'id = ?', whereArgs: [id]);
  }

  // --------- EDIT -----------
}
