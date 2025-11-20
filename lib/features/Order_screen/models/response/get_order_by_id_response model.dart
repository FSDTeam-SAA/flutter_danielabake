class GetOrderByIdResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<Order> orders;

  GetOrderByIdResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.orders,
  });

  factory GetOrderByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetOrderByIdResponseModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      orders: (json['orders'] as List)
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'pages': pages,
      'orders': orders.map((e) => e.toJson()).toList(),
    };
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
  final String createdAt;
  final String updatedAt;

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
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      address: json['address'],
      phone: json['phone'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      estimatedDelivery: json['estimatedDelivery'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'address': address,
      'phone': phone,
      'status': status,
      'paymentStatus': paymentStatus,
      'estimatedDelivery': estimatedDelivery,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      '_id': id,
    };
  }
}

class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
