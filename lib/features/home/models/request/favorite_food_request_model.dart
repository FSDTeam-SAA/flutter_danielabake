class FavoriteFoodRequestModel {
  final String userId;
  final String itemId;

  FavoriteFoodRequestModel({
    required this.userId,
    required this.itemId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "itemId": itemId,
    };
  }
}
