
class Order {
  final String id;
  String customer;
  DateTime date;
  List<OrderItem> items;

  Order({required this.id, required this.customer, required this.date, required this.items});

  double get total =>
      items.fold(0, (s, i) => s + i.qty * i.unitPrice);
}