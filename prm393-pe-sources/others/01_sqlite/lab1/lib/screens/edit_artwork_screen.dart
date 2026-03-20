import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artwork.dart';
import '../providers/artwork_provider.dart';

class EditScreen extends StatefulWidget {
  final Artwork artwork;
  const EditScreen({super.key, required this.artwork});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>(); // Native Form Key

  late TextEditingController titleCtrl;
  late TextEditingController artistCtrl;
  late TextEditingController yearCtrl;
  late TextEditingController descCtrl;

  late String selectedCategory;

  final List<String> categories = ["Abstract", "Realism", "Landscape", "Portrait"];

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.artwork.title);
    artistCtrl = TextEditingController(text: widget.artwork.artist);
    yearCtrl = TextEditingController(text: widget.artwork.year);
    selectedCategory = widget.artwork.category;
    descCtrl = TextEditingController(text: widget.artwork.description);
  }

  void update() async {
    // Native Form Validation
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ArtworkProvider>();

    Artwork updatedArt = Artwork(
      id: widget.artwork.id,
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      category: selectedCategory,
      description: descCtrl.text.trim(),
      createdBy: widget.artwork.createdBy,
    );

    await provider.updateArtwork(updatedArt);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Artwork updated successfully!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Close Edit Screen
      Navigator.pop(context); // Back to Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Artwork")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Assign Key
          child: Column(
            children: [
              TextFormField(
                controller: titleCtrl, 
                decoration: const InputDecoration(labelText: "Title *", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Title is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: artistCtrl, 
                decoration: const InputDecoration(labelText: "Artist *", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Artist is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: yearCtrl, 
                decoration: const InputDecoration(labelText: "Year *", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Year is required";
                  if (int.tryParse(v) == null) return "Year must be a number";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: descCtrl, 
                decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()), 
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: update, 
                  child: const Text("UPDATE ARTWORK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
