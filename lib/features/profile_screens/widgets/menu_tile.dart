import 'package:flutter/material.dart' hide Icons;

import '../../../core/constants/assets_const.dart';
import '../../../core/utils/app_svg.dart';

class MenuTile extends StatelessWidget {
  final String image;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0, top: 10),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFFFFEFD5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox( width: 20, height: 20, child: AppSvg(asset: image)),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: subtitle != null
                ? Text(subtitle!, style: const TextStyle(color: Colors.black54))
                : null,

            trailing: IconButton(
              onPressed: onTap,
              icon: AppSvg(asset: Images.arrow),
            ),

          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Divider(
              thickness: 1,
              height: 1,
              color: Color(0xFFAD653F),
            ),
          ),
        ],
      ),
    );
  }
}
