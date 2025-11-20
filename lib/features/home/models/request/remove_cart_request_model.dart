class RemoveCartRequestModel {
  final String userId;
  final String itemId;

  RemoveCartRequestModel({
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
