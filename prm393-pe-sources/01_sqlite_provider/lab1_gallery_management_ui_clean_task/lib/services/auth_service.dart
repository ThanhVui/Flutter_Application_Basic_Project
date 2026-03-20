import '../database/database_helper.dart';
import '../models/user.dart';

/// Database service to handle Authentication processes.
/// This includes creating new users and verifying credentials.
class AuthService {
  final dbHelper = DBHelper();

  // Task 1 – User Registration: Adds a new user account to the SQLite database.
  /// Checks for username uniqueness before final insertion. 
  /// Returns [null] on success or an error message if the username is taken.
  Future<String?> register(User user) async {
    final db = await dbHelper.database;

    // 1. Perform a check to see if the username already exists in the table
    var existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    if (existing.isNotEmpty) {
      return "Username already exists";
    }

    // 2. Perform the insertion of the new user's map data
    await db.insert('users', user.toMap());
    return null; // Return successfully without error message
  }

  // Task 2 – User Login: Verifies if a user exists with the provided credentials.
  /// Returns a [User] object if the username and password match, otherwise [null].
  Future<User?> login(String username, String password) async {
    final db = await dbHelper.database;

    // Queried users with corresponding username and password match
    var result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    // If query returns a record, map the database row into a structured User object
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }

    return null; // Authentication failed
  }
}