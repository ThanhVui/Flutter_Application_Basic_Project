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

  // Search products by title or description
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) {
      return _productsBox.values.toList();
    }
    final lowerQuery = query.toLowerCase();
    return _productsBox.values
        .where((product) =>
            product.title.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Filter products by category
  Future<List<Product>> filterProductsByCategory(String category) async {
    if (category.isEmpty || category == 'All') {
      return _productsBox.values.toList();
    }
    return _productsBox.values
        .where((product) => product.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Filter products by price range
  Future<List<Product>> filterProductsByPriceRange(double minPrice, double maxPrice) async {
    return _productsBox.values
        .where((product) => product.price >= minPrice && product.price <= maxPrice)
        .toList();
  }

  // Get all unique categories
  Future<List<String>> getAllCategories() async {
    final categories = _productsBox.values
        .map((product) => product.category)
        .toSet()
        .toList();
    categories.sort();
    return ['All', ...categories];
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    return _productsBox.get(id);
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
