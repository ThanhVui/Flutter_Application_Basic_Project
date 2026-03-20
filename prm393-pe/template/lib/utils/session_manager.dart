import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hive/hive.dart'; // <--- Task 3 (Hive): Import Hive if switching strategy

/// Helper class to manage persistent user sessions using SharedPreferences.
/// This allows the application to "remember" the user even after the app is closed.
class SessionManager {
  // Constant keys used for local storage persistence
  static const String userKey = "userId";
  static const String nameKey = "username"; 

  /// Saves both the user's ID and username to the device's local storage.
  /// This is typically called immediately after a successful login.
  static Future<void> saveUser(int userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userKey, userId);
    await prefs.setString(nameKey, username); 
  }

  /// Retrieves the stored user ID from local storage.
  /// Returns [null] if no user is currently authenticated.
  static Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userKey);
  }

  /// Retrieves the stored username from local storage.
  /// This is useful for displaying personalized home screen messages.
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  /// Clears all session-related data from the device.
  /// Called when the user clicks the "Logout" button.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(nameKey); 
  }

  /// Checks if a user session currently exists.
  /// Returns [true] if a stored user ID is found, otherwise [false].
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }
}

/*
// ==========================================================================
// ALTERNATIVE STRATEGY: HIVE (Task 3 – Session Management)
// ==========================================================================
// To use Hive, uncomment this class and comment out the SharedPreferences one.
// You must also uncomment Hive lines in 'main.dart' and 'pubspec.yaml'.

class SessionManager {
  static const String boxName = "sessionBox";

  static Future<void> saveUser(int userId, String username) async {
    var box = await Hive.openBox(boxName);
    await box.put('userId', userId);
    await box.put('username', username);
  }

  static Future<int?> getUser() async {
    var box = await Hive.openBox(boxName);
    return box.get('userId');
  }

  static Future<String?> getUsername() async {
    var box = await Hive.openBox(boxName);
    return box.get('username');
  }

  static Future<void> clearSession() async {
    var box = await Hive.openBox(boxName);
    await box.clear();
  }

  static Future<bool> isLoggedIn() async {
    var box = await Hive.openBox(boxName);
    return box.containsKey('userId');
  }
}
*/
