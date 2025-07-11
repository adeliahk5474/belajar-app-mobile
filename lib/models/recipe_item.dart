class RecipeItem {
  final String inventoryId;   // id produk/bahan di inventory
  final int qty;              // jumlah per satuan menu

  const RecipeItem({
    required this.inventoryId,
    required this.qty,
  });

  RecipeItem copyWith({String? inventoryId, int? qty}) => RecipeItem(
        inventoryId: inventoryId ?? this.inventoryId,
        qty: qty ?? this.qty,
      );
}
