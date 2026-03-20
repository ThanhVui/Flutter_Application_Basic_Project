import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/artwork.dart';
import '../providers/artwork_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';
import 'edit_artwork_screen.dart';

/// Screen displaying full details of a specific artwork using Riverpod.
/// Provides options to Edit, Delete, or Toggle Favorite status.
class DetailScreen extends ConsumerWidget {
  final Artwork artwork;
  const DetailScreen({super.key, required this.artwork});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accessing providers for metadata and database operations using Riverpod's WidgetRef
    final art = ref.read(artworkProvider);
    final favorite = ref.watch(favoriteProvider);
    final auth = ref.read(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Background color
      appBar: AppBar(
        title: const Text("Artwork Detail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. HEADER BANNER SECTION: Displays Title, Artist Initial, and Quick Labels
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D6E6E), // Dark Teal Background
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artwork.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          artwork.artist.isNotEmpty ? artwork.artist[0].toUpperCase() : "?",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildHeaderChip(artwork.year),
                      const SizedBox(width: 10),
                      _buildHeaderChip(artwork.category),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. INFORMATION CARD: Detailed metadata grid and description text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoGridRow("Artist:", artwork.artist),
                  const SizedBox(height: 12),
                  _infoGridRow("Year:", artwork.year),
                  const SizedBox(height: 12),
                  _infoGridRow("Category:", artwork.category),
                  const Divider(height: 40),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    artwork.description.isNotEmpty ? artwork.description : "No description provided.",
                    style: const TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. ACTION SECTION: Buttons for managing the artwork
            
            // Navigate to Edit Screen
            _actionButton(
              label: "Edit Artwork",
              icon: Icons.edit_rounded,
              color: const Color(0xFF0D6E6E),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => EditScreen(artwork: artwork)));
              },
            ),
            const SizedBox(height: 12),
            
            // Open Delete Confirmation Dialog
            _actionButton(
              label: "Delete Artwork",
              icon: Icons.delete_outline_rounded,
              color: Colors.white,
              textColor: const Color(0xFF0D6E6E),
              borderColor: const Color(0xFFCBD5E1),
              onPressed: () => _confirmDelete(context, art, auth.userId!),
            ),
            const SizedBox(height: 12),
            
            // FAVORITE TOGGLE: Reactively checks if the current user has liked this artwork
            FutureBuilder<bool>(
              future: favorite.checkFavorite(auth.userId!, artwork.id!),
              builder: (context, snapshot) {
                bool isFav = snapshot.data ?? false;
                return _actionButton(
                  label: isFav ? "Remove from Favorite" : "Add to Favorite",
                  icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: const Color(0xFF0D6E6E),
                  textColor: Colors.white,
                  onPressed: () async {
                    // Update favorite status in SQLite via FavoriteProvider
                    await favorite.toggleFavorite(auth.userId!, artwork.id!);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isFav ? "Removed from favorites" : "Added to favorites"), duration: const Duration(seconds: 1)),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Helper to build translucent chips for the header.
  Widget _buildHeaderChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Helper for building aligned metadata rows (Artist, Year, etc.)
  Widget _infoGridRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
        Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Reusable action button widget used for Edit, Delete, and Favorite actions.
  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  /// Displays a customized confirmation dialog before executing a permanent delete.
  void _confirmDelete(BuildContext context, ArtworkProvider provider, int userId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delete Artwork",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to delete this artwork?",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 32),
              // Horizontal arrangement of action buttons for a balanced look
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Permanent deletion from database
                        await provider.deleteArtwork(artwork.id!, userId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Artwork deleted successfully"), backgroundColor: Colors.red),
                          );
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Return to list view
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6E6E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
