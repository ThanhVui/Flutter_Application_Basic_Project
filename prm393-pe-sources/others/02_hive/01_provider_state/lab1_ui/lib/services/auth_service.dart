import 'package:hive/hive.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

/// Database service to handle Authentication processes using Hive.
class AuthService {
  /// Register: Adds a new user account to the Hive box.
  Future<String?> register(User user) async {
    var box = Hive.box<User>(HiveHelper.userBoxName);
    
    // Check if username already exists
    bool exists = box.values.any((u) => u.username == user.username);
    if (exists) {
      return "Username already exists";
    }

    // Set auto-increment ID
    user.id = box.length + 1;
    await box.add(user);
    return null; 
  }

  /// Login: Verifies if a user exists in the Hive box.
  Future<User?> login(String username, String password) async {
    var box = Hive.box<User>(HiveHelper.userBoxName);
    
    try {
      final user = box.values.firstWhere(
        (u) => u.username == username && u.password == password
      );
      return user;
    } catch (e) {
      return null; // Not found or catch error
    }
  }
}