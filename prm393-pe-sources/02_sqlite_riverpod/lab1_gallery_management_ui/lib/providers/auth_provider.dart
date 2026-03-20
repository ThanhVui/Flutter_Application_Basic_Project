import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../utils/session_manager.dart';
import '../models/user.dart';

/// Global provider instance for AuthProvider using Riverpod.
/// It uses ChangeNotifierProvider to maintain compatibility with the existing logic.
final authProvider = ChangeNotifierProvider((ref) => AuthProvider());

/// Provider class to manage the Authentication state of the application.
/// It handles login, registration, logout, and session persistence.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Internal state variables for the logged-in user
  int? _userId;
  String? _username; 

  // Public getters to access the user state from the UI
  int? get userId => _userId;
  String? get username => _username; 
  bool get isLoggedIn => _userId != null;

  /// Checks if a valid user session exists in local storage.
  /// This is called when the app starts to auto-login the user.
  Future<void> checkSession() async {
    _userId = await SessionManager.getUser();
    _username = await SessionManager.getUsername();
    notifyListeners(); // Refresh UI based on session status
  }

  /// Handles the registration of a new user.
  /// Returns an error message as a String, or null if successful.
  Future<String?> register(User user) async {
    return await _authService.register(user);
  }

  /// Authenticates the user with a username and password.
  /// If successful, saves the session locally and updates the app state.
  Future<String?> login(String username, String password) async {
    User? user = await _authService.login(username, password);
    if (user != null) {
      _userId = user.id;
      _username = user.username; 
      
      // Persist the user session to SharedPreferences
      await SessionManager.saveUser(_userId!, _username!);
      
      notifyListeners(); // Notify all listening widgets (like HomeScreen)
      return null; // Null indicates success
    }
    return "Invalid username or password";
  }

  /// Logs the user out by clearing local session data and resetting the state.
  Future<void> logout() async {
    await SessionManager.clearSession(); // Remove from local storage
    _userId = null;
    _username = null; 
    notifyListeners(); // Navigate user back to LoginScreen
  }
}
