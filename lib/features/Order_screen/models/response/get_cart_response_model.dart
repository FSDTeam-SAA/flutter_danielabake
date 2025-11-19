class GetCartResponseModel {
  final String id;
  final String userId;
  final String description;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetCartResponseModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCartResponseModel(
      id: json['_id'] as String,
      userId: json['user'] as String,
      description: json['user'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class CartItem {
  final String id;
  final ItemDetails item;
  int quantity;

  CartItem({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] as String,
      item: ItemDetails.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }
}

class ItemDetails {
  final String id;
  final String name;
  final double price;
  final String image;

  ItemDetails({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }
}
