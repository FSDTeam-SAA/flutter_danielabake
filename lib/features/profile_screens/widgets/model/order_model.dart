class OrderModel {
  final String shopName;
  final String image;
  final String orderId;
  final double amount;
  final int itemsCount;
  final bool isPaid;

  OrderModel({
    required this.shopName,
    required this.image,
    required this.orderId,
    required this.amount,
    required this.itemsCount,
    required this.isPaid,
  });
}
