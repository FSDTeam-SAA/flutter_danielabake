class CreateConversationRequestModel {
  final String userId;

  CreateConversationRequestModel({required this.userId});

  // Convert JSON to UserRequest
  factory CreateConversationRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateConversationRequestModel(
      userId: json['userId'],
    );
  }

  // Convert UserRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}
