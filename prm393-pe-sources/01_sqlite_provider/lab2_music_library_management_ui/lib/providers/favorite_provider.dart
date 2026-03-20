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

  /// Task 12: Favorite Songs Screen - Loads favorite songs and their total count from SQLite.
  /// Typically called from navigation headers and FavoriteScreen.
  Future<void> loadFavorites() async {
    _favorites = await _service.getFavorites();
    _totalFavorites = await _service.countFavorites();
    notifyListeners();
  }
  /// Task 11: Favorite Songs - Toggles the favorite status (isFavorite: 0/1) for a specific song ID.
  /// Also reloads favorite and song list to keep UI in sync.
  Future<void> toggleFavorite(Song song, SongProvider songProvider) async {
    await _service.toggleFavorite(song);

    // Refresh both providers to keep overall state consistent
    await loadFavorites();
    await songProvider.loadSongs();
  }
}
