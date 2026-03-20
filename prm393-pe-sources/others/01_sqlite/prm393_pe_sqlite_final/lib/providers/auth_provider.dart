import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final DatabaseService _dbService = DatabaseService();
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _storageService.isLoggedIn();
    _username = await _storageService.getUsername();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await _dbService.getUser(username, password);
      if (user != null) {
        await _storageService.saveUsername(username);
        await _storageService.setLoggedIn(true);
        _isLoggedIn = true;
        _username = username;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Auth Database error: $e');
      // If database fails (e.g. on Web), fallback to basic mock logic for testing
      if (username == 'admin' && password == 'password123') {
        await _storageService.saveUsername(username);
        await _storageService.setLoggedIn(true);
        _isLoggedIn = true;
        _username = username;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      // Kiểm tra username đã tồn tại chưa
      final exists = await _dbService.checkUsernameExists(username);
      if (exists) {
        debugPrint('Username already exists');
        return false;
      }

      // Tạo user mới
      final newUser = User(
        username: username,
        email: email,
        password: password,
      );

      await _dbService.registerUser(newUser);
      
      // Đăng nhập luôn sau khi đăng ký thành công
      await _storageService.saveUsername(username);
      await _storageService.setLoggedIn(true);
      _isLoggedIn = true;
      _username = username;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }
}
