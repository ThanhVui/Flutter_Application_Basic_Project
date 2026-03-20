import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';

/// Screen displaying the list of artworks marked as favorites by the current user using Riverpod.
class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure favorite data is fresh by loading it from SQLite when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authProvider).userId!;
      ref.read(favoriteProvider).loadFavorites(userId);
    });
  }

  /// Removes an artwork from the user's favorite list.
  void remove(int artworkId) async {
    final userId = ref.read(authProvider).userId!;
    // toggleFavorite handles both adding and removing based on current state
    await ref.read(favoriteProvider).toggleFavorite(userId, artworkId);
    
    if (mounted) {
      // Provide quick feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch favorite provider for real-time list updates via Riverpod
    final fav = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: fav.favorites.isEmpty
          ? const Center(child: Text("No favorites yet")) // Empty state message
          : ListView.builder(
              itemCount: fav.favorites.length,
              itemBuilder: (_, i) {
                var art = fav.favorites[i];
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