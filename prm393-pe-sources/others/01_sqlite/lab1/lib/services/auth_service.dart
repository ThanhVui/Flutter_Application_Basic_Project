import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService {
  final dbHelper = DBHelper();

  // REGISTER
  Future<String?> register(User user) async {
    final db = await dbHelper.database;

    // check username exists
    var existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    if (existing.isNotEmpty) {
      return "Username already exists";
    }

    await db.insert('users', user.toMap());
    return null; // success
  }

  // LOGIN
  Future<User?> login(String username, String password) async {
    final db = await dbHelper.database;

    var result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }

    return null;
  }
}