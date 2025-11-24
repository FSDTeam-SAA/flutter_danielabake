import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String name;
  final String avatarUrl; // Change from Color to String for image path/url

  const ChatListTile({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Stack(
          children: [
            ClipOval(
              child: Image.network(
                avatarUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // fallback if image fails to load
                  return Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.white),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Name + message
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),

      ],
    );
  }
}
