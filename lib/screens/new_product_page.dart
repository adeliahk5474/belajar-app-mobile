import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product.dart';
import '../models/recipe_item.dart';
import '../controllers/inventory_controller.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _nameCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  XFile? _pickedImage;

  final _ingredients = <RecipeItem>[];

  // ───────────────────────────────── image picker
  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _pickedImage = img);
  }

  // ───────────────────────────────── upload image ke firebase
  Future<String?> _uploadImageToFirebase(String productId) async {
    if (_pickedImage == null) return null;
    final file = File(_pickedImage!.path);
    final ref = FirebaseStorage.instance.ref().child('products/$productId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // ───────────────────────────────── tambah bahan
  Future<void> _addIngredientDialog() async {
    final inv = context.read<InventoryController>().items;
    String? selectedId;
    final qtyCtl = TextEditingController(text: '1');

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Tambah Bahan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  items:
                      inv
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => selectedId = v,
                  decoration: const InputDecoration(labelText: 'Pilih bahan'),
                ),
                TextField(
                  controller: qtyCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Qty per produk',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedId != null) {
                    _ingredients.add(
                      RecipeItem(
                        inventoryId: selectedId!,
                        qty: int.tryParse(qtyCtl.text) ?? 0,
                      ),
                    );
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
    );
  }

  // ───────────────────────────────── simpan produk baru
  Future<void> _save() async {
    if (_nameCtl.text.trim().isEmpty ||
        _priceCtl.text.trim().isEmpty ||
        _ingredients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua data')));
      return;
    }

    final id = const Uuid().v4();
    final imageUrl = await _uploadImageToFirebase(id);

    final product = Product(
      id: id,
      name: _nameCtl.text,
      category: 'Menu',
      unit: 'pcs',
      price: double.tryParse(_priceCtl.text) ?? 0,
      stockQty: 0,
      minStock: 0,
      recipe: _ingredients,
      imagePath: _pickedImage?.path,
      imageUrl: imageUrl,
    );

    Navigator.pop(context, product);
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _priceCtl.dispose();
    super.dispose();
  }

  // ───────────────────────────────── UI
  @override
  Widget build(BuildContext context) {
    final inv = context.watch<InventoryController>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Produk / Menu Baru')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _pickImage,
            child:
                _pickedImage == null
                    ? Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Text('Tap untuk pilih gambar'),
                    )
                    : Image.file(
                      File(_pickedImage!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtl,
            decoration: const InputDecoration(labelText: 'Nama produk'),
          ),
          TextField(
            controller: _priceCtl,
            decoration: const InputDecoration(labelText: 'Harga jual'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Bahan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: inv.isEmpty ? null : _addIngredientDialog,
                icon: const Icon(Icons.add),
                label: const Text('Tambah bahan'),
              ),
            ],
          ),
          ..._ingredients.map((r) {
            final p = inv.firstWhere((e) => e.id == r.inventoryId);
            return ListTile(
              title: Text(p.name),
              trailing: Text('${r.qty} ${p.unit}'),
              onLongPress: () => setState(() => _ingredients.remove(r)),
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
