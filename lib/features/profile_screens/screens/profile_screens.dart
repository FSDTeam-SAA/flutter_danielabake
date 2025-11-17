import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileController = Get.find<ProfileController>();

  // @override
  // void initState() {
  //   super.initState();
  //   _profileController.fetchProfile();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          final user = _profileController.userInfo.value;

          if (user == null) {
            return const CircularProgressIndicator(); // Loading state
          }

          return ProfileCard(
            name: user.fullName,
            imagePath: user.avatarUrl,
            orders: user.totalOrders.toString(),
            favorites: user.totalFavorites.toString(),
            onEdit: () {
              print('Edit clicked');
            },
          );
        }),
      ),
    );
  }
}
