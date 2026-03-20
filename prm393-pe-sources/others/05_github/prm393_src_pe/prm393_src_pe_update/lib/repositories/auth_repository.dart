import '../services/local_storage_service.dart';
import '../models/user.dart';

class AuthRepository {
  final LocalStorageService local;

  AuthRepository(this.local);

  Future<User?> login(String email, String password) async {
    // Actual SQLite lookup
    final map = await local.loginUser(email, password);
    if (map != null) {
      final token = "tok_${map['id']}_xyz";
      await local.saveToken(
        token, 
        email, 
        fullName: map['fullName'], 
        phone: map['phone']
      );
      return User(
        id: map['id'],
        email: email, 
        token: token, 
        fullName: map['fullName'], 
        phone: map['phone'],
      );
    }
    return null;
  }

  Future<bool> register(String email, String password, String fullName, String phone) async {
    final res = await local.registerUser(email, password, fullName, phone);
    return res != -1;
  }

  Future<User?> checkSession() async {
    return await local.getUserSession();
  }

  Future<void> logout() async {
    await local.clearSession();
  }
}
