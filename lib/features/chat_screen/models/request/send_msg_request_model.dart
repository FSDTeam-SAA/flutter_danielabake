class SendMessageRequest {
  final String text;
  final String receiverId;

  SendMessageRequest({
    required this.text,
    required this.receiverId,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'receiverId': receiverId,
    };
  }
}
