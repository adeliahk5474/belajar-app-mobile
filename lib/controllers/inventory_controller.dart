import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/recipe_item.dart';

class InventoryController extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  // ───────────────────────────── CRUD
  void addRaw({
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stockQty,
    int minStock = 0,
  }) {
    _items.add(Product(
      id: const Uuid().v4(),
      name: name,
      category: category,
      unit: unit,
      price: price,
      stockQty: stockQty,
      minStock: minStock,
    ));
    notifyListeners();
  }

  /// tambah produk/menu yang sudah dibentuk dari luar (NewProductPage)
  void addFull(Product p) {
    _items.add(p);
    notifyListeners();
  }

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

  // ───────────────────────────── stok
  /// +delta untuk menambah, ‑delta untuk mengurangi
  bool adjustStock(String id, int delta) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return false;
    final newQty = _items[i].stockQty + delta;
    if (newQty < 0) return false; // stok tidak cukup
    _items[i].stockQty = newQty;
    notifyListeners();
    return true;
  }

  bool hasEnoughStock(String id, int qty) =>
      _items.firstWhere((e) => e.id == id).stockQty >= qty;

  // ───────────────────────────── kalkulasi stok menu
  /// Kurangi seluruh bahan berdasarkan resep [recipe] * [totalQty].
  /// Return `true` jika semua stok cukup, kalau tidak ‑ tidak ada perubahan.
  bool consumeRecipe(List<RecipeItem> recipe, int totalQty) {
    // cek cukup
    for (final r in recipe) {
      if (!hasEnoughStock(r.inventoryId, r.qty * totalQty)) return false;
    }
    // kurangi
    for (final r in recipe) {
      adjustStock(r.inventoryId, -r.qty * totalQty);
    }
    return true;
  }
}
