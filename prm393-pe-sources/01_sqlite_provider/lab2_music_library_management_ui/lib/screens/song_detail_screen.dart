import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';
import '../providers/favorite_provider.dart';
// import '../providers/auth_provider.dart';
import 'edit_song_screen.dart';

/// Screen displaying full details of a specific song.
/// Provides options to Edit, Delete, or Toggle Favorite status.
/// Task 6: Song Detail - Screen displaying full details of a specific song.
class DetailScreen extends StatelessWidget {
  final Song song;
  const DetailScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    // Accessing providers for metadata and database operations
    final songProvider = context.read<SongProvider>();
    // final favoriteProvider = context.watch<FavoriteProvider>();
    // final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Background color
      appBar: AppBar(
        title: const Text(
          "Song Detail",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
                color: const Color(0xFF00796B), // Teal theme
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
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
                          song.artist.isNotEmpty
                              ? song.artist[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildHeaderChip(song.year),
                      const SizedBox(width: 10),
                      _buildHeaderChip(song.genre),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Task 6: Song Detail - Display Title, Artist, Year, Genre
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
                  _infoGridRow("Title:", song.title),
                  const SizedBox(height: 12),
                  _infoGridRow("Artist:", song.artist),
                  const SizedBox(height: 12),
                  _infoGridRow("Year:", song.year),
                  const SizedBox(height: 12),
                  _infoGridRow("Genre:", song.genre),
                  const Divider(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 3. ACTION SECTION: Buttons for managing the song

            // Navigate to Edit Screen
            _actionButton(
              label: "Edit Song",
              icon: Icons.edit_rounded,
              color: const Color(0xFF0D6E6E),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditScreen(song: song)),
                );
              },
            ),
            const SizedBox(height: 12),

            // Task 8: Delete Song - Open Delete Confirmation Dialog
            _actionButton(
              label: "Delete Song",
              icon: Icons.delete_outline_rounded,
              color: Colors.white,
              textColor: const Color(0xFF0D6E6E),
              borderColor: const Color(0xFFCBD5E1),
              onPressed: () => _confirmDelete(context, songProvider),
            ),
            const SizedBox(height: 12),

            // Task 11: Favorite Songs - Toggle Favorite feature
            Consumer<FavoriteProvider>(
              builder: (context, favProvider, child) {
                // Rely on SongProvider for the most up-to-date data for the item itself
                final songProvider = context.read<SongProvider>();
                final currentSong = songProvider.songs.firstWhere(
                  (s) => s.id == song.id,
                  orElse: () => song,
                );

                bool isFav = currentSong.isFavorite == 1;

                return _actionButton(
                  label: isFav ? "Remove from Favorite" : "Add to Favorite",
                  icon: isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: const Color(0xFF00796B),
                  textColor: Colors.white,
                  onPressed: () async {
                    // Task 11: Favorite Songs - Update isFavorite field (0/1)
                    await favProvider.toggleFavorite(currentSong, songProvider);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            currentSong.isFavorite == 1
                                ? "Added to favorites"
                                : "Removed from favorites",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Helper for building aligned metadata rows (Artist, Year, etc.)
  Widget _infoGridRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
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
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  /// Displays a customized confirmation dialog before executing a permanent delete.
  void _confirmDelete(BuildContext context, SongProvider provider) {
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
                "Delete Song",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to delete this song?",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 32),
              // Task 8: Delete Song - Confirmation Logic
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Task 8: Delete Song - Remove from database and update list
                        await provider.deleteSong(song.id!);
                        if (context.mounted) {
                          // Task 8: Delete Song - Show SnackBar notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Song deleted successfully"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Return to list view
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6E6E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
