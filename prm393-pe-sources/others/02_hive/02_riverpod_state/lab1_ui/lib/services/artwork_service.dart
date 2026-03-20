import 'package:hive/hive.dart';
import '../models/artwork.dart';
import '../database/database_helper.dart';

/// Service class to handle data-access operations for Artworks using Hive.
class ArtworkService {
  /// Create: Inserts a new Artwork into the Hive box.
  Future<void> insertArtwork(Artwork artwork) async {
    var box = Hive.box<Artwork>(HiveHelper.artworkBoxName);
    artwork.id = box.length + 1;
    await box.add(artwork);
  }

  /// Read: Fetches all artworks created by a specific user from the Hive box.
  Future<List<Artwork>> getArtworks(int userId) async {
    var box = Hive.box<Artwork>(HiveHelper.artworkBoxName);
    return box.values.where((art) => art.createdBy == userId).toList();
  }

  /// Update: Modifies existing artwork in the Hive box.
  Future<void> updateArtwork(Artwork artwork) async {
    // HiveObjects automatically update if saved via save() or if the object in box is modified
    await artwork.save();
  }

  /// Delete: Removes an artwork entry from the Hive box.
  Future<void> deleteArtwork(int id) async {
    var box = Hive.box<Artwork>(HiveHelper.artworkBoxName);
    final artworkToDelete = box.values.firstWhere((art) => art.id == id);
    await artworkToDelete.delete();
  }

  /// Search: Finds artworks by Title using case-insensitive keyword match.
  Future<List<Artwork>> searchArtworks(String keyword, int userId) async {
    var box = Hive.box<Artwork>(HiveHelper.artworkBoxName);
    return box.values
        .where((art) => 
            art.createdBy == userId && 
            art.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}