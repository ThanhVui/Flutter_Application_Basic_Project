import 'package:shared_preferences/shared_preferences.dart';

/// Helper class to manage user session using SharedPreferences.
/// This allows the application to "remember" the user even after it's closed.
class SessionManager {
  // Constant key used to store the user's ID in local storage
  static const String userKey = "userId";

  /// Saves the userId to the device's persistent storage.
  /// Called after a successful login.
  static Future<void> saveUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userKey, userId);
  }

  /// Retrieves the stored user ID from local storage.
  /// Returns [null] if no user is currently logged in.
  static Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userKey);
  }

  /// Clears the user session data (deletes the stored user ID).
  /// Called when the user clicks the "Logout" button.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  /// Checks if a user is currently logged in.
  /// Returns [true] if a stored user ID exists, otherwise [false].
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }
}
