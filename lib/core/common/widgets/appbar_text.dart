import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),);
  }
}

