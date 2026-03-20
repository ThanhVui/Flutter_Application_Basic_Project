import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artwork.dart';
import '../providers/artwork_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';
import 'edit_artwork_screen.dart';

class DetailScreen extends StatelessWidget {
  final Artwork artwork;
  const DetailScreen({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    final artworkProvider = context.read<ArtworkProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Artwork Detail"),
        actions: [
          FutureBuilder<bool>(
            future: favoriteProvider.checkFavorite(authProvider.userId!, artwork.id!),
            builder: (context, snapshot) {
              bool isFav = snapshot.data ?? false;
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                onPressed: () async {
                  await favoriteProvider.toggleFavorite(authProvider.userId!, artwork.id!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFav ? "Removed from favorites" : "Added to favorites"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.palette, size: 100, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Text(artwork.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("by ${artwork.artist}", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const Divider(height: 30),
            _infoRow("Category", artwork.category),
            _infoRow("Year", artwork.year),
            const SizedBox(height: 20),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(artwork.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditScreen(artwork: artwork)),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context, artworkProvider, authProvider.userId!),
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ArtworkProvider provider, int userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this artwork?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await provider.deleteArtwork(artwork.id!, userId);
              if (context.mounted) {
                // USER FEEDBACK: SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Artwork deleted successfully"), backgroundColor: Colors.red),
                );
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to home
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
