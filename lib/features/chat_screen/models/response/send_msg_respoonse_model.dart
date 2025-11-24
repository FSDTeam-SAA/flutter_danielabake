
class SendMsgResponseModel {
  final String conversation;
  final String sender;
  final String receiver;
  final String text;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  SendMsgResponseModel({
    required this.conversation,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SendMsgResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMsgResponseModel(
      conversation: json['conversation'],
      sender: json['sender'] is Map ? json['sender']['_id'] : json['sender'],
      receiver: json['receiver'] is Map ? json['receiver']['_id'] : json['receiver'],
      text: json['text'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation,
      'sender': sender,
      'receiver': receiver,
      'text': text,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
