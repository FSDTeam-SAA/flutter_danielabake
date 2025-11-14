import 'package:danielabake/core/common/widgets/elevated_button.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'menu_tile.dart';
import 'profile_info_box.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String orders;
  final String favorites;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.orders,
    required this.favorites,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: 70,),
          Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          SizedBox(height: 20,),


          // top row
          Container(
            decoration: BoxDecoration(color: Color(0x2EFFB972),borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(imagePath),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      PrimaryButton(onTap: (){}, label: 'Edit', width: 56, height: 30),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Divider(color: Color(0xFFAD653F),),
                  SizedBox(height: 20,),

                  Row(
                    children: const [
                      ProfileInfoBox(title: 'Orders', value: '45'),
                      SizedBox(width: 16),
                      ProfileInfoBox(title: 'Favorites', value: '12'),
                    ],
                  ),
                ],
              ),
            ),
          ),


          SizedBox(height: 30,),

          Container(
            decoration: BoxDecoration(color: Color(0x2EFFB972),borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                MenuTile(
                  icon: Icons.receipt_long,
                  title: 'My Orders',
                  subtitle: 'View past & ongoing orders',
                  onTap: () {},
                ),
                MenuTile(
                  icon: Icons.favorite_border,
                  title: 'Favorites',
                  subtitle: 'See your saved dishes',
                  onTap: () {},
                ),
                MenuTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Change your password',
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            decoration: BoxDecoration(color: Color(0x2EFFB972),borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Container(decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFFFEFD5)
              ), child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.logout, color: Colors.brown[700]),
              )),
              title: Text(
                "Logout",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              trailing: IconButton(onPressed: (){_authController.logout();}, icon: Icon(Icons.arrow_forward_ios, size: 16,
                color: Colors.black54,),),
            ),
          )

        ],
      ),
    );
  }
}
