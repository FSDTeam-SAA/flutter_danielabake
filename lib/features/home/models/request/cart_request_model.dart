class AddItemRequest {
  final String userId;
  final String itemId;
  final int quantity;

  AddItemRequest({
    required this.userId,
    required this.itemId,
    required this.quantity,
  });

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'itemId': itemId,
      'quantity': quantity,
    };
  }
}
