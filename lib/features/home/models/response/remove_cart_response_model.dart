class RemoveCartResponse {
  final String id;
  final String user;
  final List<CartRemovedItem> items;
  final int total;

  RemoveCartResponse({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
  });

  factory RemoveCartResponse.fromJson(Map<String, dynamic> json) {
    return RemoveCartResponse(
      id: json['_id'],
      user: json['user'],
      items: (json['items'] as List)
          .map((e) => CartRemovedItem.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }
}

class CartRemovedItem {
  final String id;
  final String item;
  final int quantity;

  CartRemovedItem({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartRemovedItem.fromJson(Map<String, dynamic> json) {
    return CartRemovedItem(
      id: json['_id'],
      item: json['item'],
      quantity: json['quantity'],
    );
  }
}
