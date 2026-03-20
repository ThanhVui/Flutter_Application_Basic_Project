import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductRepository {
  final ApiService api;
  final LocalStorageService local;

  ProductRepository(this.api, this.local);

  Future<List<Product>> getProducts() async {
    try {
      final products = await api.fetchProducts();
      // Cache local
      await local.saveProducts(products);
      return products;
    } catch (e) {
      // Offline mode
      print("Offline Load triggered");
      return await local.getLocalProducts();
    }
  }

  Future<Product?> addProduct(Product product) async {
    try {
      return await api.addProduct(product);
    } catch (e) {
      return null;
    }
  }

  Future<Product?> updateProduct(Product product) async {
    try {
      return await api.updateProduct(product);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await api.deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
