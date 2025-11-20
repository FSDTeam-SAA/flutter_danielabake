class CheckoutRequestModel {
  final String userId;
  final String address;
  final String phone;

  CheckoutRequestModel({
    required this.userId,
    required this.address,
    required this.phone,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "address": address,
      "phone": phone,
    };
  }

  // Create model from JSON
  factory CheckoutRequestModel.fromJson(Map<String, dynamic> json) {
    return CheckoutRequestModel(
      userId: json["userId"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}
