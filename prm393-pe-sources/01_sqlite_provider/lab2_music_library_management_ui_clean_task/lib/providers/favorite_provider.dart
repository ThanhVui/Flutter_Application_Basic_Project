import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/song.dart';
import 'song_provider.dart';

/// Provider to manage the state of favorite songs.
/// It interacts with [FavoriteService] which uses the existing songs table.
class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();

  // List of favorite song objects and their count
  List<Song> _favorites = [];
  int _totalFavorites = 0;

  // Getters for public access to private state variables
  List<Song> get favorites => _favorites;
  int get totalFavorites => _totalFavorites;

  /// Loads favorite songs and their total count from SQLite.
  /// Typically called from navigation headers and FavoriteScreen.
  Future<void> loadFavorites() async {
    _favorites = await _service.getFavorites();
    _totalFavorites = await _service.countFavorites();
    notifyListeners(); // Refresh UI for icons and badges
  }

  //   /// Toggles the favorite status of an artwork for a specific user ID.
  // /// If [isFav] is true, it removes the favorite; otherwise, it adds it.
  // Future<void> toggleFavorite(int userId, int artworkId) async {
  //   bool isFav = await _service.isFavorite(userId, artworkId);
  //   if (isFav) {
  //     await _service.removeFavorite(userId, artworkId);
  //   } else {
  //     // Create a new Favorite object and insert it into the database
  //     await _service.addFavorite(
  //       Favorite(
  //         userId: userId,
  //         artworkId: artworkId,
  //         createdAt: DateTime.now().toString(),
  //       ),
  //     );
  //   }
  //   // Refresh the local list and count so UI is updated automatically
  //   await loadFavorites(userId);
  // }

  // /// Checks if a specific artwork is favorited by a user.
  // /// Typically called to determine the color of the favorite heart icon in UI/UX.
  // Future<bool> checkFavorite(int userId, int artworkId) async {
  //   return await _service.isFavorite(userId, artworkId);

  /// Toggles the favorite status (isFavorite: 0/1) for a specific song ID.
  /// Also reloads favorite and song list to keep UI in sync.
  Future<void> toggleFavorite(Song song, SongProvider songProvider) async {
    await _service.toggleFavorite(song);

    // Refresh both providers to keep overall state consistent
    await loadFavorites();
    await songProvider.loadSongs();
  }
}
