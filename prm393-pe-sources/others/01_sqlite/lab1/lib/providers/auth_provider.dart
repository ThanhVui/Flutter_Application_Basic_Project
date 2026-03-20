import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/session_manager.dart';
import '../models/user.dart';

/// Provider to handle authentication state and user session
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Stores the ID of the currently logged-in user
  int? _userId;

  // Getters to access private variables
  int? get userId => _userId;
  bool get isLoggedIn => _userId != null;

  /// Checks if a user is already logged in when the app starts.
  /// It reads from local storage (SharedPreferences) via SessionManager.
  Future<void> checkSession() async {
    _userId = await SessionManager.getUser();
    notifyListeners(); // Update UI if session exists
  }

  /// Handles user registration.
  /// user object containing registration details.
  /// Returns null on success or an error message as a String.
  Future<String?> register(User user) async {
    String? result = await _authService.register(user);
    return result;
  }

  /// Handles user login.
  /// Validates credentials against the SQLite database and saves the session if successful.
  Future<String?> login(String username, String password) async {
    User? user = await _authService.login(username, password);
    if (user != null) {
      _userId = user.id;
      // Save user ID to local storage to stay logged in
      await SessionManager.saveUser(_userId!);
      notifyListeners();
      return null; // Return null to indicate Success
    }
    return "Invalid username or password";
  }

  /// Logs the user out.
  /// Clears the session from both memory and local storage.
  Future<void> logout() async {
    await SessionManager.clearSession();
    _userId = null;
    notifyListeners();
  }
}
