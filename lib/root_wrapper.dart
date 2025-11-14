import 'package:danielabake/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/splash_screen/screens/splash_screen.dart';

class RootWrapper extends StatelessWidget {
  const RootWrapper({super.key});

  Future<bool> _refresh() async {
    final auth = Get.find<AuthController>();
    return await auth.refreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const NavigationMenu();
        }

        return const SplashScreen();
      },
    );
  }
}

