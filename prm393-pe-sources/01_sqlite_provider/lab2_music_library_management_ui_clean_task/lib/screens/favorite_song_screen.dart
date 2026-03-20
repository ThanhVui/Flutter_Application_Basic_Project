import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/song_provider.dart';
import '../models/song.dart';

/// Screen displaying the list of songs marked as favorites (isFavorite == 1).
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorite-only data from the dedicated FavoriteProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  /// Toggles the favorite status of a song.
  void toggleFav(Song song) async {
    final songProvider = context.read<SongProvider>();
    await context.read<FavoriteProvider>().toggleFavorite(song, songProvider);

    if (mounted) {
      // Provide visual feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            song.isFavorite == 1 ? "Added to favorites" : "Removed from favorites",
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch FavoriteProvider specifically for real-time list updates
    final favProvider = context.watch<FavoriteProvider>();
    final favorites = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Songs"),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite songs yet.",
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (_, i) {
                var song = favorites[i];
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(
                    song.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${song.artist} • ${song.year}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => toggleFav(song),
                  ),
                );
              },
            ),
    );
  }
}
