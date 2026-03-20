import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/artwork.dart';
import '../models/favorite.dart';

/// Provider to manage the state of favorite artworks.
/// It interacts with the FavoriteService to implement favoriting features.
class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service = FavoriteService();
  
  // List of artwork objects that have been favorited by the current user
  List<Artwork> _favorites = [];
  int _totalFavorites = 0;

  // Getters for public access to private state variables
  List<Artwork> get favorites => _favorites;
  int get totalFavorites => _totalFavorites;

  /// Loads all favorite artworks and the total count for a user ID.
  /// Used primarily on the [HomeScreen] dashboard and the [FavoriteScreen].
  Future<void> loadFavorites(int userId) async {
    _favorites = await _service.getFavorites(userId);
    _totalFavorites = await _service.countFavorites(userId);
    notifyListeners(); // Notify UI components that favorited list has changed
  }

  /// Toggles the favorite status of an artwork for a specific user ID.
  /// If [isFav] is true, it removes the favorite; otherwise, it adds it.
  Future<void> toggleFavorite(int userId, int artworkId) async {
    bool isFav = await _service.isFavorite(userId, artworkId);
    if (isFav) {
      await _service.removeFavorite(userId, artworkId);
    } else {
      // Create a new Favorite object and insert it into the database
      await _service.addFavorite(
        Favorite(
          userId: userId,
          artworkId: artworkId,
          createdAt: DateTime.now().toString(),
        ),
      );
    }
    // Refresh the local list and count so UI is updated automatically
    await loadFavorites(userId); 
  }

  /// Checks if a specific artwork is favorited by a user.
  /// Typically called to determine the color of the favorite heart icon in UI/UX.
  Future<bool> checkFavorite(int userId, int artworkId) async {
    return await _service.isFavorite(userId, artworkId);
  }
}
