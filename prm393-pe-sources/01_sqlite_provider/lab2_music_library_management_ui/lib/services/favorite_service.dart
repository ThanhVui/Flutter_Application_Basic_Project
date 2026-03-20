import '../database/database_helper.dart';
import '../models/song.dart';

/// Database service specialized in user favorite artwork management.
/// It implements intermediate table operations joining 'artworks' and 'favorites'.
class FavoriteService {
  final dbHelper = DBHelper();

  /// Adds an artwork to the user's favorite list.
  /// Prevents duplicate entries. Returns [null] on success, otherwise an error message.
  Future<String?> addFavorite(Favorite fav) async {
    final db = await dbHelper.database;

    // 1. Check if the artwork is already favorited by this specific user
    var existing = await db.query(
      'favorites',
      where: 'userId = ? AND songId = ?',
      whereArgs: [fav.userId, fav.songId],
    );

    if (existing.isNotEmpty) {
      return "Already in favorites";
    }

    // 2. Perform insertion using the Favorite object's map
    await db.insert('favorites', fav.toMap());
    return null;
  }

  /// Retrieves all artwork objects that a user has favorited.
  /// Uses an INNER JOIN SQL query to link the favorites table back to the artwork data.
  Future<List<Song>> getFavorites() async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT songs.* FROM songs
      INNER JOIN favorites 
      ON songs.id = favorites.songId
    ''');

    // Map query raw results into structured Song model objects
    return result.map((e) => Song.fromMap(e)).toList();
  }

  /// Checks if a specific artwork [songId] is already favorited by a user.
  Future<bool> isFavorite(int userId, int songId) async {
    final db = await dbHelper.database;
    var result = await db.query(
      'favorites',
      where: 'userId = ? AND songId = ?',
      whereArgs: [userId, songId],
    );
    return result.isNotEmpty;
  }

  /// Removes an artwork from the user's favorites collection.
  Future<int> removeFavorite(int userId, int songId) async {
    final db = await dbHelper.database;

    return await db.delete(
      'favorites',
      where: 'songId = ?',
      whereArgs: [songId],
    );
  }

  /// Calculates the total number of favorite items for a given user.
  /// Result is typically displayed as a summary statistic on the HomeScreen.
  Future<int> countFavorites(int userId) async {
    final db = await dbHelper.database;

    var result = await db.rawQuery('SELECT COUNT(*) as count FROM favorites');

    // SQL COUNT results are returned as an integer map entry
    return result.first['count'] as int;
  }
}
