import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/utils/app_svg.dart';
import '../controller/message_controller.dart';

class MessagingScreen extends StatefulWidget {
  final String conversationId;
  final String adminId;

  const MessagingScreen({
    super.key,
    required this.conversationId,
    required this.adminId,
  });

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final MessageController msgController = Get.put(MessageController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    msgController.getAdmin(); // fetch admin info
  }

  void fetchMessages() async {
    await msgController.getAllMessage(widget.conversationId);

    // Scroll to bottom after messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    // Listen for changes and scroll automatically
    msgController.messages.listen((_) => scrollToBottom());
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    await msgController.sendMsg(text, widget.adminId, widget.conversationId);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Obx(() {
          final admin = msgController.admin.value;
          return Text(
            admin?.name ?? 'Chat',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          );
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 16, right: 16, top: 20),
        decoration: const BoxDecoration(
          color: Color(0x8FFFFFFF),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0x2EFFB972),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SizedBox(
                  height: 30,
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: sendMessage,
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: const BoxDecoration(
                  color: Color(0x2EFFB972),
                  shape: BoxShape.circle,
                ),
                child: AppSvg(asset: Images.msg),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final msgs = msgController.messages;

                if (msgs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final msg = msgs[index];

                    return MessageBubble(
                      text: msg.text,
                      time: msg.createdAt.toLocal().toString().substring(11, 16),
                        isMe: msg.sender != widget.adminId // user message -> right, admin -> left
                    );
                  },
                );

              }),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                colors: [
                  Color(0x99237EF4),
                  Color(0x991153FA),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
                  : null,
              color: isMe ? null : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 18),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              time,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          )
        ],
      ),
    );
  }
}
