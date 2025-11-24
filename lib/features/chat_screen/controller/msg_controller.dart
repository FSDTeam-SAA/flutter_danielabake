import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Reactive message list
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = messageController.text.trim();
    final now = TimeOfDay.now();
    final time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    messages.add({"text": newMessage, "time": time, "isMe": true});
    messageController.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}
