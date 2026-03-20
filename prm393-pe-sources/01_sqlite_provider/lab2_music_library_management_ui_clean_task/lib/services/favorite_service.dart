import '../database/database_helper.dart';
import '../models/song.dart';

/// Database service specialized in managing song favorites.
/// Instead of a separate table, it uses the 'isFavorite' column in the 'songs' table.
class FavoriteService {
  final dbHelper = DBHelper();

  /// Retrieves all songs that have been marked as favorites (isFavorite = 1).
  Future<List<Song>> getFavorites() async {
    final db = await dbHelper.database;

    // final result = await db.rawQuery('''
    //   SELECT songs.* FROM songs
    //   INNER JOIN favorites
    //   ON songs.id = favorites.songId
    // ''');
    final result = await db.query('songs', where: 'isFavorite = 1');

    // Map query results into Song model objects
    return result.map((e) => Song.fromMap(e)).toList();
  }

  /// Calculates the total number of favorite songs.
  Future<int> countFavorites() async {
    final db = await dbHelper.database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM songs WHERE isFavorite = 1',
    );
    return result.first['count'] as int;
  }

  /// Toggles the favorite status (0 <-> 1) for a song in the main songs table.
  Future<int> toggleFavorite(Song song) async {
    final db = await dbHelper.database;
    int newValue = song.isFavorite == 1 ? 0 : 1;
    song.isFavorite = newValue; // Correct: Update the object in memory too

    return await db.update(
      'songs',
      {'isFavorite': newValue},
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }
}
