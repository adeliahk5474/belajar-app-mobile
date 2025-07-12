import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/order_item.dart';

class OrderItemEditPage extends StatefulWidget {
  final OrderItem item;
  const OrderItemEditPage({super.key, required this.item});

  @override
  State<OrderItemEditPage> createState() => _OrderItemEditPageState();
}

class _OrderItemEditPageState extends State<OrderItemEditPage> {
  late final qtyCtl = TextEditingController(text: widget.item.qty.toString());
  late final priceCtl = TextEditingController(
    text: widget.item.unitPrice.toStringAsFixed(0),
  );
  late final noteCtl = TextEditingController(text: widget.item.note);

  XFile? _pickedImage;

  // ───────────────────────── pick
  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _pickedImage = img);
  }

  // ───────────────────────── upload
  Future<String?> _upload() async {
    if (_pickedImage == null) return widget.item.imageUrl;
    final file = File(_pickedImage!.path);
    final ref = FirebaseStorage.instance.ref().child(
      'order_items/${widget.item.productId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  void _save() async {
    final url = await _upload();

    final updated = widget.item.copyWith(
      qty: int.tryParse(qtyCtl.text) ?? widget.item.qty,
      unitPrice: double.tryParse(priceCtl.text) ?? widget.item.unitPrice,
      note: noteCtl.text,
      imageUrl: url,
      imagePath: _pickedImage?.path,
    );
    if (!mounted) return;
    Navigator.pop(context, updated);
  }

  @override
  void dispose() {
    qtyCtl.dispose();
    priceCtl.dispose();
    noteCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preview = () {
      if (_pickedImage != null) {
        return Image.file(
          File(_pickedImage!.path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else if (widget.item.imageUrl != null &&
          widget.item.imageUrl!.isNotEmpty) {
        return Image.network(
          widget.item.imageUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else {
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image),
        );
      }
    }();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: GestureDetector(onTap: _pickImage, child: preview)),
          const SizedBox(height: 16),
          TextField(
            controller: qtyCtl,
            decoration: const InputDecoration(labelText: 'Qty'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceCtl,
            decoration: const InputDecoration(labelText: 'Harga satuan'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: noteCtl,
            decoration: const InputDecoration(labelText: 'Catatan'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ],
      ),
    );
  }
}
