import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';

/// Screen displaying the list of artworks marked as favorites by the current user.
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure favorite data is fresh by loading it from SQLite when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId!;
      context.read<FavoriteProvider>().loadFavorites(userId);
    });
  }

  /// Removes an artwork from the user's favorite list.
  void remove(int artworkId) async {
    final userId = context.read<AuthProvider>().userId!;
    // toggleFavorite handles both adding and removing based on current state
    await context.read<FavoriteProvider>().toggleFavorite(userId, artworkId);

    if (mounted) {
      // Provide quick feedback to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch favorite provider for real-time list updates
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favoriteProvider.favorites.isEmpty
          ? const Center(child: Text("No favorites yet")) // Empty state message
          : ListView.builder(
              itemCount: favoriteProvider.favorites.length,
              itemBuilder: (_, i) {
                var art = favoriteProvider.favorites[i];
                // Display each favorite artwork as a ListTile
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(art.title),
                  subtitle: Text("${art.artist} • ${art.year}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    // Action to unmark as favorite
                    onPressed: () => remove(art.id!),
                  ),
                );
              },
            ),
    );
  }
}
