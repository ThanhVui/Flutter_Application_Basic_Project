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

  /// Fetches all songs from the database for a specific user.
  /// Notifies listeners to show/hide loading indicators during the process.
  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    // Fetch data asynchronously from SQLite
    _songs = await _service.getSongs();

    _isLoading = false;
    notifyListeners();
  }

  /// Adds a new song to the database.
  /// After adding, it automatically refreshes the local list to keep the UI in sync.
  Future<void> addSong(Song song) async {
    await _service.insertSong(song);
    // Refresh the list for the user who created it
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
  // void filter(String category, String year, int userId) async {
  //   // 1. Get a fresh copy of all user songs
  //   List<Song> all = await _service.getSongs(userId);

  //   // 2. Apply filtering logic on the collection
  //   _songs = all.where((e) {
  //     // Category filter: match if "All" is selected or if specific category matches
  //     bool catMatch = category == "All" || e.category == category;

  //     // Year filter: match if "All" is selected or if song was created in last 5 years
  //     bool yearMatch = year == "All";
  //     if (year == "Last 5 years") {
  //       int current = DateTime.now().year;
  //       int? artYear = int.tryParse(e.year);
  //       yearMatch = artYear != null && (current - artYear <= 5);
  //     }

  //     return catMatch && yearMatch;
  //   }).toList();

  //   notifyListeners(); // Refresh the list view in the UI
  // }
}
