import 'package:shared_preferences/shared_preferences.dart';

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
