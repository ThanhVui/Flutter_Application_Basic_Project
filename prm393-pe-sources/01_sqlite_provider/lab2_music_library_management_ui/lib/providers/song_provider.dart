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

  /// Task 4: Home Screen (Song List) - Fetches all songs from the database.
  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    _songs = await _service.getSongs(); // Task 4: Load data from database

    _isLoading = false;
    notifyListeners();
  }

  /// Task 5: Add Song - Adds a new song to the database.
  Future<void> addSong(Song song) async {
    await _service.insertSong(song); // Task 5: Save to database
    await loadSongs(); // Task 5: Update song list
  }

  /// Task 7: Update Song - Updates an existing song's details.
  Future<void> updateSong(Song song) async {
    await _service.updateSong(song); // Task 7: Save to database
    await loadSongs(); // Task 7: Update immediately on Home Screen
  }

  /// Task 8: Delete Song - Deletes a song from the database.
  Future<void> deleteSong(int id) async {
    await _service.deleteSong(id); // Task 8: Remove from database
    await loadSongs(); // Task 8: Update list
  }

  /// Task 9: Search Songs - Searches songs by Title or Artist.
  Future<void> search(String keyword) async {
    _songs = await _service.searchSongs(keyword); // Task 9: Filter results in real-time
    notifyListeners();
  }

  /// Task 10: Filter Songs - Filters songs by Genre and Year.
  void filter(String genre, String year) async {
    // 1. Get a fresh copy of all songs
    List<Song> all = await _service.getSongs();

    // 2. Task 10: Filter logic for Genre and Year (Current, Last 5 years, All)
    _songs = all.where((e) {
      bool genreMatch = genre == "All" || e.genre == genre;

      bool yearMatch = year == "All";
      int current = DateTime.now().year;
      int? songYear = int.tryParse(e.year);

      if (year == "Last 5 years") {
        yearMatch = songYear != null && (current - songYear <= 5);
      } else if (year == "Current year") {
        yearMatch = songYear != null && (current - songYear == 0);
      }

      return genreMatch && yearMatch;
    }).toList();

    notifyListeners(); // Refresh the list view in the UI
  }
}
