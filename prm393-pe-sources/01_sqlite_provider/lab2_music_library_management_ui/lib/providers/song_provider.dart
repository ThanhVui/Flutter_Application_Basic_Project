import 'package:flutter/material.dart';
import '../services/song_service.dart';
import '../models/song.dart';

/// Provider for managing songs logic and state.
/// It interacts with [SongService] to handle core CRUD operations and filtering.
class SongProvider extends ChangeNotifier {
  final SongService _service = SongService();

  // Internal state: List of songs currently displayed and loading status
  List<Song> _songs = [];
  bool _isLoading = false;

  // Public getters to expose state to the UI (e.g., HomeScreen)
  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  int get totalSongs => _songs.length;

  /// Fetches all songs from the database.
  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    _songs = await _service.getSongs();

    _isLoading = false;
    notifyListeners();
  }

  /// Adds a new song to the database.
  Future<void> addSong(Song song) async {
    await _service.insertSong(song);
    await loadSongs();
  }

  /// Updates an existing song's details.
  /// Re-fetches the database content upon successful modification.
  Future<void> updateSong(Song song) async {
    await _service.updateSong(song);
    await loadSongs();
  }

  /// Deletes an song from the database using its unique [id].
  /// Requires [userId] to refresh the correct user's collection list.
  Future<void> deleteSong(int id) async {
    await _service.deleteSong(id);
    await loadSongs();
  }

  /// Searches songs by title keyword for a specific user.
  /// Updates the [_songs] list reactively as the user types in the search bar.
  Future<void> search(String keyword) async {
    _songs = await _service.searchSongs(keyword);
    notifyListeners();
  }

  /// Filters songs based on category and creation year.
  /// Logic: Fetches all songs then applies filters locally for better performance.
  void filter(String genre, String year) async {
    // 1. Get a fresh copy of all user songs
    List<Song> all = await _service.getSongs();

    // 2. Apply filtering logic on the collection
    _songs = all.where((e) {
      // Genre filter: match if "All" is selected or if specific category matches
      bool genreMatch = genre == "All" || e.genre == genre;

      // Year filter: match if "All" is selected or if song was created in last 5 years
      bool yearMatch = year == "All";
      if (year == "Last 5 years") {
        int current = DateTime.now().year;
        int? songYear = int.tryParse(e.year);
        yearMatch = songYear != null && (current - songYear <= 5);
      } else if (year == "currentYear") {
        int current = DateTime.now().year;
        int? songYear = int.tryParse(e.year);
        yearMatch = songYear != null && (current - songYear == 0);
      }

      return genreMatch && yearMatch;
    }).toList();

    notifyListeners(); // Refresh the list view in the UI
  }
}
