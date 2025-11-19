class OrderResponse {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  OrderResponse({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['_id'],
      userId: json['user'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: json['total'] as double,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

class OrderItem {
  final String itemId;
  final int quantity;
  final String id;

  OrderItem({
    required this.itemId,
    required this.quantity,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['item'],
      quantity: json['quantity'],
      id: json['_id'],
    );
  }
}
