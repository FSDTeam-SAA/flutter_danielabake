import 'package:danielabake/core/common/widgets/elevated_button.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/features/auth/controller/auth_controller.dart';
import 'package:danielabake/features/profile_screens/screens/change_password_screen.dart';
import 'package:danielabake/features/profile_screens/screens/favorite_items.dart';
import 'package:danielabake/features/profile_screens/screens/my_orders_screen.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/utils/app_svg.dart';
import '../screens/edit_profile_screen.dart';
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
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircleAvatar(
                          backgroundImage: imagePath.isNotEmpty
                              ? NetworkImage(imagePath)
                              : const AssetImage(Images.profile1) as ImageProvider,
                        ),
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
                      PrimaryButton(onTap: (){Get.to(() => EditProfileScreen());}, label: 'Edit', width: 56, height: 30),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Divider(color: Color(0xFFAD653F),),
                  SizedBox(height: 20,),

                  Row(
                    children: [
                      ProfileInfoBox(title: 'Orders', value: orders),
                      const SizedBox(width: 16),
                      ProfileInfoBox(title: 'Favorites', value: favorites),
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
                  image: Images.orders,
                  title: 'My Orders',
                  subtitle: 'View past & ongoing orders',
                  onTap: () {Get.to(() => MyOrdersScreen());},
                ),
                MenuTile(
                  image: Images.favorite,
                  title: 'Favorites',
                  subtitle: 'See your saved dishes',
                  onTap: () {Get.to(() => FavoriteItems());},
                ),
                MenuTile(
                  image: Images.settings,
                  title: 'Settings',
                  subtitle: 'Change your password',
                  onTap: () {Get.to(() => ChangePasswordScreen());},
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            decoration: BoxDecoration(
              color: Color(0x2EFFB972),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: (){_authController.logout();},
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFFFEFD5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppSvg(asset: Images.logout),
                  ),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                trailing:AppSvg(asset: Images.arrow),

              ),
            ),
          )

        ],
      ),
    );
  }
}
