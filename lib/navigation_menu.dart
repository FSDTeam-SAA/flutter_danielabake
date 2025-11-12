//
// import 'package:danielabake/core/utils/app_svg.dart';
// import 'package:danielabake/features/Order_screen/screens/order_screens.dart';
// import 'package:danielabake/features/chat_screen/screens/chat_screens.dart';
// import 'package:danielabake/features/home/screens/home_screen.dart';
// import 'package:danielabake/features/profile_screens/screens/profile_screens.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'core/constants/assets_const.dart';
//
//
// class NavigationMenu extends StatelessWidget {
//   const NavigationMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//     return Scaffold(
//       bottomNavigationBar: Obx(
//             () => NavigationBar(
//           height: 80,
//           elevation: 0,
//           selectedIndex: controller.selectedIndex.value,
//           backgroundColor: Color(0x38FFFFFF),
//           onDestinationSelected: (index) => controller.selectedIndex.value = index,
//           indicatorColor: Color(0xD11B76FF),
//           destinations: [
//             NavigationDestination(icon: AppSvg(asset: Images.home), label: 'Home'),
//             NavigationDestination(icon: AppSvg(asset: Images.order), label: 'Store'),
//             NavigationDestination(icon: AppSvg(asset: Images.chat), label: 'Wishlist'),
//             NavigationDestination(icon: AppSvg(asset: Images.profile), label: 'Profile'),
//           ],
//         ),
//       ),
//
//       body: Obx( () =>  controller.screen[controller.selectedIndex.value]),
//     );
//   }
// }
//
// class NavigationController extends GetxController {
//   final Rx<int> selectedIndex = 0.obs;
//   final screen = [
//     const HomeScreen(),
//      const OrderScreens(),
//     const ChatScreens(),
//     const ProfileScreens(),
//   ];
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:danielabake/core/utils/app_svg.dart';
import 'package:danielabake/core/constants/assets_const.dart';
import 'package:danielabake/features/home/screens/home_screen.dart';
import 'package:danielabake/features/Order_screen/screens/order_screens.dart';
import 'package:danielabake/features/chat_screen/screens/chat_screens.dart';
import 'package:danielabake/features/profile_screens/screens/profile_screens.dart';

import 'core/common/constants/app_colors.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Color(0xFFFFF1DB), // soft background like image
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300
            ),
            color: const Color(0xFFFFF3E8),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // increased from 0.05 to 0.15
                blurRadius: 12,                        // slightly larger blur
                offset: const Offset(0, 4),            // move shadow a bit further down
              ),
            ],

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.items.length, (index) {
              final item = controller.items[index];
              final isSelected = controller.selectedIndex.value == index;

              return GestureDetector(
                onTap: () => controller.selectedIndex.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xD11B76FF)           // selected background
                        : const Color(0x26E89208),          // unselected background (15% opacity)
                    borderRadius: BorderRadius.circular(100),
                  ),

                  child: Row(
                    children: [
                      AppSvg(
                        asset: item['icon'],
                        height: 22,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF713C1B), // brown icons
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Map<String, dynamic>> items = [
    {'icon': Images.home, 'label': 'Home'},
    {'icon': Images.order, 'label': 'Store'},
    {'icon': Images.chat, 'label': 'Chat'},
    {'icon': Images.profile, 'label': 'Profile'},
  ];

  final List<Widget> screens = [
    const HomeScreen(),
    const OrderScreens(),
    const ChatScreens(),
    const ProfileScreen(),
  ];
}

