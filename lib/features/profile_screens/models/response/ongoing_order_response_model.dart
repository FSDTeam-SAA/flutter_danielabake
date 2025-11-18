class OngoingOrderResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<Order> orders;

  OngoingOrderResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.orders,
  });

  factory OngoingOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OngoingOrderResponseModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      orders: (json['orders'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
    );
  }
}

class Order {
  final String id;
  final String user;
  final List<OrderItem> items;
  final double totalAmount;
  final String address;
  final String phone;
  final String status;
  final String paymentStatus;
  final String estimatedDelivery;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
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

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      user: json['user'],
      items: (json['items'] as List)
          .map((itemJson) => OrderItem.fromJson(itemJson))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      address: json['address'],
      phone: json['phone'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      estimatedDelivery: json['estimatedDelivery'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      item: Item.fromJson(json['item']),
      quantity: json['quantity'],
      id: json['_id'],
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
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}
