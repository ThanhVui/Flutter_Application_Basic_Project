import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/song_provider.dart';
import '../providers/favorite_provider.dart';
import '../models/song.dart';
import 'favorite_song_screen.dart';
import 'add_song_screen.dart';
import 'edit_song_screen.dart';
import 'song_detail_screen.dart';
import 'login_screen.dart';

/// Main Dashboard screen displaying a summary of the gallery.
/// Includes banners, statistics, search/filter functionality, and the song list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local state for current filter selections
  String selectedCategory = "All";
  String selectedYear = "All";

  @override
  void initState() {
    super.initState();
    // Load initial data from SQLite via Providers after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().loadSongs();
      // context.read<FavoriteProvider>().loadFavorites(userId);
    });
  }

  /// Task 3: Logout - Clears the user session and navigates back to the LoginScreen.
  void logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      // Task 3: Logout - Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logged out successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // Task 9: Search Songs - Triggers a live search based on the user's keystrokes.
  void search(String keyword) {
    context.read<SongProvider>().search(keyword);
  }

  // Task 10: Filter Songs - Applies the selected Category and Year filters to the song list.
  void applyFilter() {
    context.read<SongProvider>().filter(selectedCategory, selectedYear);
  }

  /// Helper to calculate the unique number of categories available in the current collection.
  // int countCategories() {
  //   final songs = context.read<SongProvider>().songs;
  //   final categories = songs.map((e) => e.category).toSet();
  //   return categories.length;
  // }

  @override
  Widget build(BuildContext context) {
    // Watching providers to reactively update the UI when data changes
    final authProvider = context.watch<AuthProvider>();
    final songProvider = context.watch<SongProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate-light background
      appBar: AppBar(
        title: const Text(
          "Gallery Dashboard",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Task 12: Favorite Songs Screen - Navigation to the Favorites sub-screen
          IconButton(
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: Color(0xFF64748B),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),

          // Task 3: Logout - Logout button on App Bar
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF64748B)),
            onPressed: logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BRAND BANNER SECTION: Displays the decorative header image
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'lib/assets/gallery_header.jpg',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. WELCOME SECTION: Greets the logged-in user with their name from AuthProvider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF148585),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        color: Color(0xFF148585),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gallery Collection",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Welcome back, ${authProvider.username ?? 'User'}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // // 3. STATISTICS SECTION: Quick overview of Songs, Favorites, and Categories
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            //   child: Text(
            //     "Gallery Statistics",
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(24),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         _statCard(
            //           Icons.photo_library_outlined,
            //           SongProvider.totalSongs.toString(),
            //           "Songs",
            //         ),
            //         _statCard(
            //           Icons.favorite_border_rounded,
            //           favoriteProvider.totalFavorites.toString(),
            //           "Favorites",
            //         ),
            //         _statCard(
            //           Icons.category_outlined,
            //           countCategories().toString(),
            //           "Categories",
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // // Task: 4. SEARCH & FILTERS SECTION: Responsive inputs for narrowing down the collection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Task 9: Search Songs - Add a Search Bar on Home Screen
                    TextField(
                      onChanged: search, // Logic for real-time search
                      decoration: InputDecoration(
                        hintText: "Search by title or artist...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Task 10: Filter Songs - Allow filtering by Genre and Year
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            "Year Filter", // Filter by Year: Current, Last 5 years, All
                            selectedYear,
                            ["All", "Last 5 years", "Current year"],
                            (v) {
                              setState(() => selectedYear = v!);
                              applyFilter();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown(
                            "Genre Filter", // Filter by Genre (Pop, Rock, Ballad, EDM)
                            selectedCategory,
                            ["All", "Pop", "Rock", "Ballad", "EDM"],
                            (v) {
                              setState(() => selectedCategory = v!);
                              applyFilter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 5. ARTWORK COLLECTION LIST: Dynamically rendered list of the user's songs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                "Song Collection (${songProvider.songs.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Task 4: Home Screen (Song List) - ListView.builder to load from DB
            songProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: songProvider.songs.length,
                    itemBuilder: (_, index) {
                      var song = songProvider.songs[index];
                      bool isFav = song.isFavorite == 1;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7F3D0).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.music_note_rounded,
                              color: Color(0xFF065F46),
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${song.artist} • ${song.year}",
                            style: const TextStyle(color: Color(0xFF64748B)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Quick Task Action: Favorite
                              IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? Colors.red
                                      : const Color(0xFF64748B),
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await favoriteProvider.toggleFavorite(
                                    song,
                                    songProvider,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          song.isFavorite == 1
                                              ? "Added to favorites"
                                              : "Removed from favorites",
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              ),
                              // Quick Task Action: Edit
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditScreen(song: song),
                                    ),
                                  );
                                },
                              ),
                              // Quick Task Action: Delete
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _confirmDelete(context, songProvider, song),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(song: song),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
            const SizedBox(
              height: 100,
            ), // Ensures scroll space for the FloatingActionButton
          ],
        ),
      ),
      // Task 5: Add Song - Action button to navigate to the 'Add Song' Screen
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA7F3D0),
        foregroundColor: const Color(0xFF065F46),
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Song",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSongScreen()),
          );
        },
      ),
    );
  }

  /// Reusable widget for displaying a single statistics metric.
  // Widget _statCard(IconData icon, String value, String label) {
  //   return Expanded(
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 4),
  //       padding: const EdgeInsets.symmetric(vertical: 12),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF8FAFC),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         children: [
  //           Icon(icon, color: const Color(0xFF148585), size: 20),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xFF1E293B),
  //             ),
  //           ),
  //           Text(
  //             label,
  //             style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Reusable widget to build labeled dropdown menus used for filtering.
  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  /// Icon Delete On Item Displays a customized confirmation dialog before executing a permanent delete.
  void _confirmDelete(BuildContext context, SongProvider provider, Song song) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delete Song",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to delete this song?",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await provider.deleteSong(song.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Song deleted successfully"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.pop(context); // Close dialog
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6E6E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
