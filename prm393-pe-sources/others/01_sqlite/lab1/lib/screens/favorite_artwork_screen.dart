import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId!;
      context.read<FavoriteProvider>().loadFavorites(userId);
    });
  }

  void remove(int artworkId) async {
    final userId = context.read<AuthProvider>().userId!;
    await context.read<FavoriteProvider>().toggleFavorite(userId, artworkId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favoriteProvider.favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favoriteProvider.favorites.length,
              itemBuilder: (_, i) {
                var art = favoriteProvider.favorites[i];
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(art.title),
                  subtitle: Text("${art.artist} • ${art.year}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => remove(art.id!),
                  ),
                );
              },
            ),
    );
  }
}