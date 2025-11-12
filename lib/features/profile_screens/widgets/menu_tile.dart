import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0, top: 10),
      child: Column(
        children: [
          ListTile(
            leading: Container(decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(50),
                color: Color(0xFFFFEFD5)
      ), child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon, color: Colors.brown[700]),
      )),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            onTap: onTap,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Divider(thickness: 1, height: 1, color: Color(0xFFAD653F)),
          ),
        ],
      ),
    );
  }
}
