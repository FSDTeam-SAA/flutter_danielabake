class OrderModel {
  final String restaurantName;
  final String orderId;
  final String image;
  final double price;
  final int totalItems;
  final bool isPaid;

  OrderModel({
    required this.restaurantName,
    required this.orderId,
    required this.image,
    required this.price,
    required this.totalItems,
    required this.isPaid,
  });
}
