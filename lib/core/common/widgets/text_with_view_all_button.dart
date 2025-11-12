import 'package:flutter/material.dart';

class TextWithViewAllButton extends StatelessWidget {
  const TextWithViewAllButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
        TextButton(onPressed: onTap, child: Text('View all', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1753FF)),))
      ],
    );
  }
}
