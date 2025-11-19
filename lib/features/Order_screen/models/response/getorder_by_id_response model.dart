class GetOrderByIdResponseModel {
  final String id;
  final User user;
  final List<OrderItem> items;
  final double totalAmount;
  final String address;
  final String phone;
  final String status;
  final String paymentStatus;
  final String estimatedDelivery;
  final String createdAt;
  final String updatedAt;

  GetOrderByIdResponseModel({
    required this.id,
    required this.user,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.phone,
    required this.status,
    required this.paymentStatus,
    required this.estimatedDelivery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetOrderByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetOrderByIdResponseModel(
      id: json["_id"],
      user: User.fromJson(json["user"]),
      items: (json["items"] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: (json["totalAmount"] as num).toDouble(),
      address: json["address"],
      phone: json["phone"],
      status: json["status"],
      paymentStatus: json["paymentStatus"],
      estimatedDelivery: json["estimatedDelivery"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
    );
  }
}

class OrderItem {
  final Item item;
  final int quantity;
  final String id;

  OrderItem({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      item: Item.fromJson(json["item"]),
      quantity: json["quantity"],
      id: json["_id"],
    );
  }
}

class Item {
  final String id;
  final String name;
  final double price;
  final String image;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["_id"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      image: json["image"],
    );
  }
}
