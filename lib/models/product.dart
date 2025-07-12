import 'recipe_item.dart';

class Product {
  final String id;
  String name;
  String category; // bebas: “Bahan”, “Menu”, dst.
  String unit; // pcs, kg, pack …
  double price; // harga jual / satuan
  int stockQty; // stok tersedia (untuk bahan)
  int minStock;
  int? cloudStockQty; // opsional dari Firebase
  String? imageUrl; // URL Firebase Storage
  List<RecipeItem>? recipe; // null = produk biasa, != null = menu
  String? imagePath; // path lokal (opsional)

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.stockQty,
    this.minStock = 0,
    this.cloudStockQty,
    this.imageUrl,
    this.recipe,
    this.imagePath,
  });

  bool get isMenu => recipe != null && recipe!.isNotEmpty;

  Product copyWith({
    String? name,
    String? category,
    String? unit,
    double? price,
    int? stockQty,
    int? minStock,
    int? cloudStockQty,
    String? imageUrl,
    List<RecipeItem>? recipe,
    String? imagePath,
  }) => Product(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    unit: unit ?? this.unit,
    price: price ?? this.price,
    stockQty: stockQty ?? this.stockQty,
    minStock: minStock ?? this.minStock,
    cloudStockQty: cloudStockQty ?? this.cloudStockQty,
    imageUrl: imageUrl ?? this.imageUrl,
    recipe: recipe ?? this.recipe,
    imagePath: imagePath ?? this.imagePath,
  );

  /// factory helper untuk membuat produk kosong (fallback)
  static Product empty() =>
      Product(id: '', name: '', category: '', unit: '', price: 0, stockQty: 0);
}
