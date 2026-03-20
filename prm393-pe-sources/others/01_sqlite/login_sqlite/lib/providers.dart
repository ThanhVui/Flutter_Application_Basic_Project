import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'database_helper.dart';

// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use');
});

// AuthService provider
final authServiceProvider = Provider<AuthService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(prefs);
});

// Auth state
class AuthState {
  final bool isLoggedIn;
  final String? username;

  AuthState({required this.isLoggedIn, this.username});

  AuthState copyWith({bool? isLoggedIn, String? username}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService)
      : super(AuthState(isLoggedIn: _authService.isLoggedIn, username: _authService.username));

  Future<bool> login(String username, String password) async {
    final db = DatabaseHelper.instance;
    final result = await db.checkLogin(username, password);
    if (result > 0) {
      await _authService.setLoggedIn(true);
      await _authService.setUsername(username);
      state = AuthState(isLoggedIn: true, username: username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(isLoggedIn: false, username: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

// Product model
class Product {
  final int? id;
  final String name;
  final double price;
  final String description;

  Product({this.id, required this.name, required this.price, this.description = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String? ?? '',
    );
  }
}

// Product notifier
class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final db = DatabaseHelper.instance;
      final results = await db.getAllProducts();
      final products = results.map((e) => Product.fromMap(e)).toList();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(Product product) async {
    final db = DatabaseHelper.instance;
    await db.insertProduct(product.toMap());
    await loadProducts();
  }

  Future<void> updateProduct(int id, Product product) async {
    final db = DatabaseHelper.instance;
    await db.updateProduct(id, product.toMap());
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteProduct(id);
    await loadProducts();
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier();
});