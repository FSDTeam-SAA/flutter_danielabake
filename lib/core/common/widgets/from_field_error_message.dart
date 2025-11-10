import 'package:flutter/material.dart';

class FormFieldErrorMessage extends StatelessWidget {
  final dynamic message;
  final Color? color;
  
  const FormFieldErrorMessage({
    super.key,
    this.message,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || 
        (message is String && message.isEmpty) ||
        (message is Map && message.isEmpty)) {
      return SizedBox.shrink();
    }
    
    if (message is String) {
      return Text(
        message as String,
        style: TextStyle(
          color: color,
          fontSize: 14,
        ),
      );
    }
    
    if (message is Map<String, String>) {
      final errors = message as Map<String, String>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors.entries.map((entry) {
          return Text(
            entry.value,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          );
        }).toList(),
      );
    }
    
    return SizedBox.shrink();
  }
}