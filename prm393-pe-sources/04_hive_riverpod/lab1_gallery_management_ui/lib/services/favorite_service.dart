import 'package:hive/hive.dart';
import '../models/favorite.dart';
import '../models/artwork.dart';
import '../database/database_helper.dart';

/// Database service specialized in user favorite artwork management using Hive.
class FavoriteService {
  /// Adds an artwork to the user's favorite box. 
  Future<String?> addFavorite(Favorite fav) async {
    var box = Hive.box<Favorite>(HiveHelper.favoriteBoxName);
    
    bool exists = box.values.any((f) => f.userId == fav.userId && f.artworkId == fav.artworkId);
    if (exists) {
      return "Already in favorites";
    }

    fav.id = box.length + 1;
    await box.add(fav);
    return null;
  }

  /// Retrieves all artworks favorited by a user.
  /// Manually joins the favorite box with the artwork box via their respective IDs.
  Future<List<Artwork>> getFavorites(int userId) async {
    var favBox = Hive.box<Favorite>(HiveHelper.favoriteBoxName);
    var artBox = Hive.box<Artwork>(HiveHelper.artworkBoxName);

    // Get list of artwork IDs favorited by the user
    final favIds = favBox.values
        .where((f) => f.userId == userId)
        .map((f) => f.artworkId)
        .toSet();

    // Map those IDs to the actual Artwork objects
    return artBox.values.where((art) => favIds.contains(art.id)).toList();
  }

  /// Checks if a specific artwork is favorited by the current user.
  Future<bool> isFavorite(int userId, int artworkId) async {
    var box = Hive.box<Favorite>(HiveHelper.favoriteBoxName);
    return box.values.any((f) => f.userId == userId && f.artworkId == artworkId);
  }

  /// Removes an artwork from the user's favorite collection in Hive.
  Future<void> removeFavorite(int userId, int artworkId) async {
    var box = Hive.box<Favorite>(HiveHelper.favoriteBoxName);
    try {
      final favorite = box.values.firstWhere(
        (f) => f.userId == userId && f.artworkId == artworkId
      );
      await favorite.delete();
    } catch (e) {
      // Handle the case where the entry is not found
    }
  }

  /// Counts total number of favorite items for a given user.
  Future<int> countFavorites(int userId) async {
    var box = Hive.box<Favorite>(HiveHelper.favoriteBoxName);
    return box.values.where((f) => f.userId == userId).length;
  }
}