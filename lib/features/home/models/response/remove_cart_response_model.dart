class RemoveCartResponseModel {
  final String id;
  final String user;
  final List<CartItem> items;
  final double total;
  final String createdAt;
  final String updatedAt;
  final int v;

  RemoveCartResponseModel({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory RemoveCartResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveCartResponseModel(
      id: json["_id"],
      user: json["user"],
      items: List<CartItem>.from(
          json["items"].map((x) => CartItem.fromJson(x))),
      total: json["total"]?.toDouble() ?? 0.0,
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }
}

class CartItem {
  final String item;
  final int quantity;
  final String id;

  CartItem({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: json["item"],
      quantity: json["quantity"],
      id: json["_id"],
    );
  }
}
