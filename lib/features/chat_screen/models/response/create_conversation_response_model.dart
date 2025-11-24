class CreateConversationResponseModel {
  final String id;
  final List<String> participants;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CreateConversationResponseModel({
    required this.id,
    required this.participants,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CreateConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateConversationResponseModel(
      id: json["_id"],
      participants: List<String>.from(json["participants"]),
      lastMessageAt: DateTime.parse(json["lastMessageAt"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "participants": participants,
      "lastMessageAt": lastMessageAt.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "__v": v,
    };
  }
}
