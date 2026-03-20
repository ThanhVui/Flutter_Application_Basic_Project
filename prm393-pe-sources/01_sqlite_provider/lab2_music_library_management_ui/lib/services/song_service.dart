import '../database/database_helper.dart';
import '../models/song.dart';

/// Service class to handle data-access operations for Songs.
/// Bridges the communication between providers and the database.
class SongService {
  final dbHelper = DBHelper();

  /// Create: Inserts a new Song entry into the SQLite 'songs' table.
  Future<int> insertSong(Song song) async {
    final db = await dbHelper.database;
    // Converts the Dart [Song] object into a Map for the SQL engine
    return await db.insert('songs', song.toMap());
  }

  /// Read: Fetches all songs created by a specific user from the database.
  Future<List<Song>> getSongs() async {
    final db = await dbHelper.database;

    // Queried songs based on the 'createdBy' user ID filter
    final result = await db.query(
      'songs',
      // where: 'createdBy = ?',
      // whereArgs: [userId],
    );

    // Map each row in the query result back into a structured Song object
    return result.map((e) => Song.fromMap(e)).toList();
  }

  /// Update: Modifies existing song details in the SQLite database based on its ID.
  Future<int> updateSong(Song song) async {
    final db = await dbHelper.database;

    return await db.update(
      'songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  /// Delete: Removes an song entry from the database using its primary key [id].
  Future<int> deleteSong(int id) async {
    final db = await dbHelper.database;

    return await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  /// Search: Finds songs by Title using SQL 'LIKE' pattern matching for a specific user.
  Future<List<Song>> searchSongs(String keyword) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'songs',
      where: 'title LIKE ?', // Case-insensitive title search
      whereArgs: ['%$keyword%'],
    );

    return result.map((e) => Song.fromMap(e)).toList();
  }
}
