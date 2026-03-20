import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';

/// Screen for editing an existing song's details.
/// Pre-fills the form with current song data from the selected object.
class EditScreen extends StatefulWidget {
  final Song song; // The song object to be edited
  const EditScreen({super.key, required this.song});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  // Late-initialized controllers to capture modified input
  late TextEditingController titleCtrl;
  late TextEditingController artistCtrl;
  late TextEditingController yearCtrl;
  late TextEditingController genreCtrl;

  late String selectedCategory;

  // Available categories for the dropdown selection
  final List<String> categories = [
    "Abstract",
    "Realism",
    "Landscape",
    "Portrait",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the current values of the song
    titleCtrl = TextEditingController(text: widget.song.title);
    artistCtrl = TextEditingController(text: widget.song.artist);
    yearCtrl = TextEditingController(text: widget.song.year);
    genreCtrl = TextEditingController(text: widget.song.genre);
    // descCtrl = TextEditingController(text: widget.song.description);
  }

  /// Task 7: Update Song - Collects updated data, validates fields, and sends update request to SQLite.
  void update() async {
    // Task 7: Update Song - Validate input fields
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SongProvider>();

    // Task 7: Update Song - Build updated Song object (Modify any field)
    Song updatedSong = Song(
      id: widget.song.id,
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      genre: genreCtrl.text.trim(),
      isFavorite: widget.song.isFavorite, // Keep original favorite status
    );

    // Task 7: Update Song - Save to database and Update immediately
    await provider.updateSong(updatedSong);

    if (mounted) {
      // Task 7: Update Song - Update UI and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Song updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close the EditScreen modal
      Navigator.pop(context); // Go back to Home to refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Themed background
      appBar: AppBar(
        title: const Text(
          "Edit Song",
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
                  "Update Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 32),

                // Existing Title Edit Field
                _buildTextField(
                  controller: titleCtrl,
                  label: "Title",
                  icon: Icons.title_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Title is required" : null,
                ),
                const SizedBox(height: 20),

                // Existing Artist Edit Field
                _buildTextField(
                  controller: artistCtrl,
                  label: "Artist",
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Artist is required" : null,
                ),
                const SizedBox(height: 20),

                // Existing Year Edit Field
                _buildTextField(
                  controller: yearCtrl,
                  label: "Year",
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Year is required";
                    if (int.tryParse(v) == null) return "Year must be a number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category Update Dropdown
                // DropdownButtonFormField<String>(
                //   value: selectedCategory,
                //   decoration: InputDecoration(
                //     labelText: "Category",
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

                // Description Update Field
                _buildTextField(
                  controller: genreCtrl,
                  label: "Genre",
                  icon: Icons.notes_rounded,
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Primary action to commit changes to DB
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: update,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF0D6E6E,
                      ), // Header-matching Teal
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "UPDATE ARTWORK",
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

  /// Utility to generate styled text fields consistently with icons and rounded borders.
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
