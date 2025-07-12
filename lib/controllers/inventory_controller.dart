import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/recipe_item.dart';

class InventoryController extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  // ──────────────────── tambah produk lokal
  void addRaw({
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stockQty,
    int minStock = 0,
    int? cloudStockQty,
    String? imageUrl,
  }) {
    _items.add(
      Product(
        id: const Uuid().v4(),
        name: name,
        category: category,
        unit: unit,
        price: price,
        stockQty: stockQty,
        minStock: minStock,
        cloudStockQty: cloudStockQty,
        imageUrl: imageUrl,
      ),
    );
    notifyListeners();
  }

  // ──────────────────── tambah produk yang sudah jadi (NewProductPage)
  void addFull(Product p) {
    _items.add(p);
    notifyListeners();
  }

  // ──────────────────── update (nama, stok, gambar, dll)
  void update(Product p) {
    final i = _items.indexWhere((e) => e.id == p.id);
    if (i != -1) {
      _items[i] = p;
      notifyListeners();
    }
  }

  void remove(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ──────────────────── stok lokal
  bool adjustStock(String id, int delta) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return false;
    final newQty = _items[i].stockQty + delta;
    if (newQty < 0) return false;
    _items[i].stockQty = newQty;
    notifyListeners();
    return true;
  }

  bool hasEnoughStock(String id, int qty) =>
      _items.firstWhere((e) => e.id == id).stockQty >= qty;

  // ──────────────────── stok bahan untuk menu
  bool consumeRecipe(List<RecipeItem> recipe, int totalQty) {
    for (final r in recipe) {
      if (!hasEnoughStock(r.inventoryId, r.qty * totalQty)) return false;
    }
    for (final r in recipe) {
      adjustStock(r.inventoryId, -r.qty * totalQty);
    }
    return true;
  }

  // ──────────────────── (opsional) set image/url sesudah upload
  void setImage(String productId, String imageUrl) {
    final i = _items.indexWhere((p) => p.id == productId);
    if (i != -1) {
      _items[i] = _items[i].copyWith(imageUrl: imageUrl);
      notifyListeners();
    }
  }

  // ──────────────────── (opsional) sync cloud stock
  void updateCloudStock(String productId, int cloudQty) {
    final i = _items.indexWhere((p) => p.id == productId);
    if (i != -1) {
      _items[i] = _items[i].copyWith(cloudStockQty: cloudQty);
      notifyListeners();
    }
  }
}
