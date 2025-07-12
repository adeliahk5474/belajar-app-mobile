class OrderItem {
  final String productId; // ID produk (mengacu ke model Product)
  String note; // Catatan tambahan (opsional)
  int qty; // Jumlah
  double unitPrice; // Harga per unit

  OrderItem({
    required this.productId,
    this.note = '',
    required this.qty,
    required this.unitPrice,
  });

  double get subtotal => qty * unitPrice;

  OrderItem copyWith({String? note, int? qty, double? unitPrice}) => OrderItem(
    productId: productId,
    note: note ?? this.note,
    qty: qty ?? this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
  );
}
