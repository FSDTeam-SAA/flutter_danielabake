class RemoveFavoriteFoodRequestModel {
  final String userId;
  final String itemId;

  RemoveFavoriteFoodRequestModel({
    required this.userId,
    required this.itemId,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'itemId': itemId,
    };
  }
}
