import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';
import '../providers/auth_provider.dart';

/// Screen for adding a new artwork to the collection.
/// Includes a Form with validation for Title, Artist, Year, and Description.
class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  // Key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // Text controllers to capture user input
  final titleCtrl = TextEditingController();
  final artistCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final genreCtrl = TextEditingController();

  // Predefined categories for the dropdown menu
  String selectedCategory = "Abstract";
  final List<String> categories = [
    "Abstract",
    "Realism",
    "Landscape",
    "Portrait",
  ];

  /// Gathers input data, validates it, and saves a new Song to SQLite.
  void save() async {
    // 1. Run native Flutter field validators
    if (!_formKey.currentState!.validate()) return;

    final songProvider = context.read<SongProvider>();

    // 2. Map text field values to a new Song model instance
    Song song = Song(
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      genre: genreCtrl.text.trim(),
      isFavorite: 0,
    );

    // 3. Persist the new song using the provider
    await songProvider.addSong(song);

    if (mounted) {
      // 4. Provide visual feedback and return to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Song added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light background
      appBar: AppBar(
        title: const Text(
          "Add Song",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New Song",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 32),

                // Input for Song Title
                _buildTextField(
                  controller: titleCtrl,
                  label: "Title",
                  icon: Icons.title_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Title is required" : null,
                ),
                const SizedBox(height: 20),

                // Input for Artist Name
                _buildTextField(
                  controller: artistCtrl,
                  label: "Artist",
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Artist is required" : null,
                ),
                const SizedBox(height: 20),

                // Input for Compilation Year with numeric check
                _buildTextField(
                  controller: yearCtrl,
                  label: "Year",
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Year is required";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Input for Compilation Genre with numeric check
                _buildTextField(
                  controller: genreCtrl,
                  label: "Genre",
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Genre is required";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // // Selection for Song Category
                // DropdownButtonFormField<String>(
                //   value: selectedCategory,
                //   decoration: InputDecoration(
                //     labelText: "",
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //     prefixIcon: const Icon(
                //       Icons.category_outlined,
                //       color: Color(0xFF64748B),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 20,
                //       vertical: 16,
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(16.0),
                //       borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(16.0),
                //       borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                //     ),
                //   ),
                //   items: categories
                //       .map(
                //         (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                //       )
                //       .toList(),
                //   onChanged: (value) =>
                //       setState(() => selectedCategory = value!),
                // ),
                // const SizedBox(height: 20),

                // Multi-line input for Description
                // _buildTextField(
                //   controller: descCtrl,
                //   label: "Description",
                //   icon: Icons.notes_rounded,
                //   maxLines: 4,
                //   validator: (v) => (v == null || v.isEmpty)
                //       ? "Description is required"
                //       : null,
                // ),
                // const SizedBox(height: 32),

                // Main save action button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B), // Teal Theme
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save Song",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to create consistently styled TextFields across the form.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      validator: validator,
    );
  }
}
