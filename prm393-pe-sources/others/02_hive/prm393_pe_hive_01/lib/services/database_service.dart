import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String productsBoxName = 'products';
  static const String usersBoxName = 'users';

  late Box<Product> _productsBox;
  late Box<User> _usersBox;

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(UserAdapter());

    _productsBox = await Hive.openBox<Product>(productsBoxName);
    _usersBox = await Hive.openBox<User>(usersBoxName);

    if (_productsBox.isEmpty) {
      await _seedProducts();
    }

    if (_usersBox.isEmpty) {
      await _seedUsers();
    }
  }

  Future<void> _seedProducts() async {
    final mockData = [
      Product(
        id: 1,
        title: 'Smartphone',
        price: 699.99,
        description: 'A high-end smartphone with a beautiful display.',
        category: 'electronics',
        image: '',
        isFavorite: false,
      ),
      Product(
        id: 2,
        title: 'Casual Shirt',
        price: 29.99,
        description: 'Comfortable cotton shirt for everyday wear.',
        category: "men's clothing",
        image: '',
        isFavorite: true,
      ),
      Product(
        id: 3,
        title: 'Silver Ring',
        price: 150.00,
        description: 'Elegant silver ring for special occasions.',
        category: 'jewelery',
        image: '',
        isFavorite: false,
      ),
    ];

    for (var product in mockData) {
      await _productsBox.put(product.id, product);
    }
  }

  Future<void> _seedUsers() async {
    final defaultUser = User(
      username: 'admin',
      password: 'password123',
      email: 'admin@example.com',
    );
    await _usersBox.put(defaultUser.username, defaultUser);
  }

  // Product methods
  Future<void> insertProduct(Product product) async {
    await _productsBox.put(product.id, product);
  }

  Future<void> updateProduct(Product product) async {
    await _productsBox.put(product.id, product);
  }

  Future<void> deleteProduct(int id) async {
    await _productsBox.delete(id);
  }

  Future<List<Product>> getProducts() async {
    return _productsBox.values.toList();
  }

  Future<bool> isFavorite(int id) async {
    final product = _productsBox.get(id);
    return product?.isFavorite ?? false;
  }

  // User methods
  Future<void> registerUser(User user) async {
    await _usersBox.put(user.username, user);
  }

  Future<bool> checkUsernameExists(String username) async {
    return _usersBox.containsKey(username);
  }

  Future<User?> getUser(String username, String password) async {
    final user = _usersBox.get(username);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }
}
