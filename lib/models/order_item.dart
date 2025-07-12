class OrderItem {
  final String productId;
  int qty;
  double unitPrice;
  String note;
  String? imageUrl; // ← gambar di cloud
  String? imagePath; // ← path lokal sementara

  OrderItem({
    required this.productId,
    required this.qty,
    required this.unitPrice,
    this.note = '',
    this.imageUrl,
    this.imagePath,
  });

  double get subtotal => qty * unitPrice;

  OrderItem copyWith({
    int? qty,
    double? unitPrice,
    String? note,
    String? imageUrl,
    String? imagePath,
  }) => OrderItem(
    productId: productId,
    qty: qty ?? this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
    note: note ?? this.note,
    imageUrl: imageUrl ?? this.imageUrl,
    imagePath: imagePath ?? this.imagePath,
  );
}
