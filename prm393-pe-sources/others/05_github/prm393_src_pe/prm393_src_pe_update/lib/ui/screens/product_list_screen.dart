import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'add_edit_product_screen.dart';
import 'cart_screen.dart';
import 'order_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productStateProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productStateProvider);
    final cart = ref.watch(cartStateProvider);

    final filteredProducts = productState.products.where((p) {
      bool matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == "All" || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final categories = ["All", ...productState.products.map((p) => p.category).toSet().toList()];

    return Scaffold(
      appBar: AppBar(
        // Feature 1: Sync on Left
        leading: IconButton(
          icon: const Icon(Icons.sync_outlined, color: Colors.white),
          onPressed: () {
            ref.read(productStateProvider.notifier).fetchProducts();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Syncing...")));
          },
        ),
        title: const Text('Home'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          // Feature 2: Cart icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Badge(
              label: Text(cart.items.length.toString()),
              isLabelVisible: cart.items.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
          ),
          // Feature 3: History next to Profile
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list_outlined, color: Colors.teal),
                    onPressed: () => _showFilterDialog(categories),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedCategory != "All")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Chip(
                label: Text("Category: $_selectedCategory"),
                onDeleted: () => setState(() => _selectedCategory = "All"),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(productStateProvider.notifier).fetchProducts(),
              child: productState.isLoading && productState.products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : productState.error != null && productState.products.isEmpty
                      ? Center(child: Text(productState.error!))
                      : LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) => _buildItem(filteredProducts[index]),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) => _buildItem(filteredProducts[index]),
                            );
                          }
                        }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addProduct'),
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFilterDialog(List<String> categories) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(padding: EdgeInsets.all(16.0), child: Text("Filter by Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(categories[index]),
                trailing: _selectedCategory == categories[index] ? const Icon(Icons.check, color: Colors.teal) : null,
                onTap: () {
                  setState(() => _selectedCategory = categories[index]);
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Product product) {
    return ProductCard(
      product: product,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditProductScreen(product: product))),
      onDelete: () => _confirmDelete(product.id!),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () { ref.read(productStateProvider.notifier).deleteProduct(id); Navigator.pop(context); }, child: const Text("Delete")),
        ],
      ),
    );
  }
}
