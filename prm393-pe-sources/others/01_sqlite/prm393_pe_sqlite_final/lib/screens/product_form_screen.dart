import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../services/notification_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _yearController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _artistdByController;
  late final TextEditingController _createdByController;
  late String _selectedCategory;

  bool get isEditing => widget.product != null;

  final List<String> _categories = ['Realism', 'Abstract', "Landscape"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _artistdByController = TextEditingController(
      text: widget.product?.artist ?? '',
    );

    _yearController = TextEditingController(
      text: widget.product?.year.toString() ?? '',
    );
    _createdByController = TextEditingController(
      text: widget.product?.createdBy.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _selectedCategory = widget.product?.category ?? 'Landscape';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    _artistdByController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        // Update existing product
        widget.product!.title = _titleController.text;
        widget.product!.year = int.parse(_yearController.text);
        widget.product!.description = _descriptionController.text;
        widget.product!.category = _selectedCategory;
        widget.product!.artist = _artistdByController.text;

        context.read<ProductProvider>().updateProduct(widget.product!);

        NotificationService().showNotification(
          2,
          'Artist Updated',
          '"${widget.product!.title}" has been updated.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artist updated successfully')),
        );
      } else {
        // Add new product
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _titleController.text,
          year: int.parse(_yearController.text),
          description: _descriptionController.text,
          category: _selectedCategory,
          artist: _artistdByController.text,
          createdBy: 0,

          // createdBy:_createdByController,
        );

        context.read<ProductProvider>().addProduct(newProduct);

        NotificationService().showNotification(
          1,
          'Artist Added',
          'New Artist "${newProduct.title}" has been added to inventory.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artist added successfully')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Artist' : 'Add New Artist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Artist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
