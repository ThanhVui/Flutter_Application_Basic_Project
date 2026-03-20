import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<int> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final favorites = productProvider.products.where((p) => p.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIds.isEmpty ? 'Favorites' : '${_selectedIds.length} selected'),
        actions: [
          if (_selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteSelected(productProvider),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) =>
                        _buildProductCard(context, favorites[index]),
                  );
                } else {
                  return ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) =>
                        _buildProductTile(context, favorites[index]),
                  );
                }
              },
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final isSelected = _selectedIds.contains(product.id);
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _navigateToDetail(context, product),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${product.price.toStringAsFixed(2)}'),
                    IconButton(
                      icon: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () =>
                          context.read<ProductProvider>().toggleFavorite(product),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(product.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, Product product) {
    final isSelected = _selectedIds.contains(product.id);
    
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => _toggleSelection(product.id),
          ),
          Container(
            width: 50,
            height: 50,
            color: Colors.grey[200],
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ],
      ),
      title: Text(product.title),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: Icon(
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: product.isFavorite ? Colors.red : null,
        ),
        onPressed: () =>
            context.read<ProductProvider>().toggleFavorite(product),
      ),
      onTap: () => _navigateToDetail(context, product),
    );
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _deleteSelected(ProductProvider productProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Favorites'),
        content: Text('Remove ${_selectedIds.length} item(s) from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (final id in _selectedIds) {
                final product = productProvider.products.firstWhere((p) => p.id == id);
                productProvider.toggleFavorite(product);
              }
              Navigator.pop(context);
              setState(() => _selectedIds.clear());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
