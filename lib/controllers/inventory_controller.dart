import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../dao/product_dao.dart'; // DAO → SQLite
import '../models/product.dart';
import '../models/recipe_item.dart';

class InventoryController extends ChangeNotifier {
  final ProductDao _dao = ProductDao();

  final List<Product> _items = [];
  List<Product> get items => List.unmodifiable(_items);

  // ───────────────────────────── init: load sekali dari DB
  InventoryController() {
    _loadFromDB();
  }

  Future<void> _loadFromDB() async {
    _items
      ..clear()
      ..addAll(await _dao.fetchAll());
    notifyListeners();
  }

  // ───────────────────────────── CRUD

  Future<void> addRaw({
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stockQty,
    int minStock = 0,
    int? cloudStockQty,
    String? imageUrl,
  }) async {
    final p = Product(
      id: const Uuid().v4(),
      name: name,
      category: category,
      unit: unit,
      price: price,
      stockQty: stockQty,
      minStock: minStock,
      cloudStockQty: cloudStockQty,
      imageUrl: imageUrl,
    );
    await _dao.insert(p);
    _items.add(p);
    notifyListeners();
  }

  Future<void> addFull(Product p) async {
    await _dao.insert(p);
    _items.add(p);
    notifyListeners();
  }

  Future<void> update(Product p) async {
    await _dao.update(p);
    final i = _items.indexWhere((e) => e.id == p.id);
    if (i != -1) {
      _items[i] = p;
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    await _dao.delete(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ───────────────────────────── stok lokal
  Future<bool> adjustStock(String id, int delta) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return false;
    final newQty = _items[i].stockQty + delta;
    if (newQty < 0) return false;
    final updated = _items[i].copyWith(stockQty: newQty);
    await _dao.update(updated);
    _items[i] = updated;
    notifyListeners();
    return true;
  }

  bool hasEnoughStock(String id, int qty) =>
      _items.firstWhere((e) => e.id == id).stockQty >= qty;

  // ───────────────────────────── stok bahan untuk menu
  Future<bool> consumeRecipe(List<RecipeItem> recipe, int totalQty) async {
    for (final r in recipe) {
      if (!hasEnoughStock(r.inventoryId, r.qty * totalQty)) return false;
    }
    for (final r in recipe) {
      await adjustStock(r.inventoryId, -r.qty * totalQty);
    }
    return true;
  }

  // ───────────────────────────── setter gambar / cloud stock
  Future<void> setImage(String productId, String imageUrl) async {
    final i = _items.indexWhere((p) => p.id == productId);
    if (i != -1) {
      final updated = _items[i].copyWith(imageUrl: imageUrl);
      await _dao.update(updated);
      _items[i] = updated;
      notifyListeners();
    }
  }

  Future<void> updateCloudStock(String productId, int cloudQty) async {
    final i = _items.indexWhere((p) => p.id == productId);
    if (i != -1) {
      final updated = _items[i].copyWith(cloudStockQty: cloudQty);
      await _dao.update(updated);
      _items[i] = updated;
      notifyListeners();
    }
  }
}
